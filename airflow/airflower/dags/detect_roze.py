import airflow
from airflow.operators.bash_operator import BashOperator
from airflow.models import DAG

args = {
    'owner': 'Freddy Drennan',
    'start_date': airflow.utils.dates.days_ago(2),
    'email': ['drennanfreddy@gmail.com'],
    'email_on_failure': True,
    'email_on_retry': True
}
# noinspection PyInterpreter
dag = DAG(dag_id='detect_roze',
          default_args=args,
          schedule_interval='*/10 * * * *',
          concurrency=1,
          max_active_runs=1,
          catchup=False)


task_1 = BashOperator(
    task_id='detect_roze',
    bash_command='. /home/scripts/R/shell/detect_roze',
    dag=dag
)



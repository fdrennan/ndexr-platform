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

dag = DAG(dag_id='update_ip',
          default_args=args,
          schedule_interval='@hourly',
          concurrency=1,
          max_active_runs=1,
          catchup=False)


task_1 = BashOperator(
    task_id='update_ip',
    bash_command='. /home/scripts/R/shell/update_ip',
    dag=dag
)



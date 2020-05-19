import airflow
from airflow.operators.bash_operator import BashOperator
from airflow.models import DAG

args = {
    'owner': 'Freddy Drennan',
    'start_date': airflow.utils.dates.days_ago(2),
    'email': ['drennanfreddy@gmail.com'],
    'retries': 100,
    'email_on_failure': True,
    'email_on_retry': True
}
dag = DAG(dag_id='update_elastic_search',
          default_args=args,
          schedule_interval='@hourly',
          concurrency=1,
          max_active_runs=1,
          catchup=False)

task = BashOperator(
    task_id='aws_configure',
    bash_command='. /home/scripts/R/shell/aws_configure',
    dag=dag
)

task_0 = BashOperator(
    task_id='stream_all_submissions_to_elastic',
    bash_command='. /home/scripts/R/shell/stream_all_submissions_to_elastic',
    dag=dag
)

task   >> task_0

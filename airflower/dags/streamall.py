import airflow
from airflow.operators.bash_operator import BashOperator
from airflow.models import DAG
from datetime import timedelta

args = {
    'owner': 'Freddy Drennan',
    'start_date': airflow.utils.dates.days_ago(2),
    'email': ['drennanfreddy@gmail.com'],
    'retries': 100,
    'retry_delay': timedelta(minutes=1),
    'email_on_failure': True,
    'email_on_retry': True
}

dag = DAG(dag_id='streamall',
          default_args=args,
          schedule_interval=None,
          concurrency=1,
          max_active_runs=1,
          catchup=False)

task_1 = BashOperator(
    task_id='set_up_aws',
    bash_command='. /home/scripts/R/shell/aws_configure',
    dag=dag
)

task_2 = BashOperator(
    task_id='streamall',
    bash_command='. /home/scripts/R/shell/streamall',
    dag=dag
)

task_1 >> task_2
import airflow
from airflow.operators.bash_operator import BashOperator
from airflow.models import DAG

args = {
    'owner': 'Freddy Drennan',
    'start_date': airflow.utils.dates.days_ago(2),
    'email': ['drennanfreddy@gmail.com'],
    'retries': 2,
    'email_on_failure': True,
    'email_on_retry': True
}
dag = DAG(dag_id='backup_postgres_to_s3',
          default_args=args,
          schedule_interval='@daily',
          concurrency=1,
          max_active_runs=1,
          catchup=False)


task_1 = BashOperator(
    task_id='set_up_aws',
    bash_command='. /home/scripts/R/shell/aws_configure',
    dag=dag
)


task_2 = BashOperator(
    task_id='backup_postgres_to_s3',
    bash_command='. /home/scripts/R/shell/create_postgres_tar',
    dag=dag
)

task_1 >> task_2
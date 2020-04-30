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
dag = DAG(dag_id='refresh_materialized_views',
          default_args=args,
          schedule_interval='*/15 * * * *',
          concurrency=1,
          max_active_runs=1,
          catchup=False)


task_0 = BashOperator(
    task_id='stream_submission_to_s3',
    bash_command='. /home/scripts/R/shell/stream_submission_to_s3',
    dag=dag
)

task_1 = BashOperator(
    task_id='streamtos3',
    bash_command='. /home/scripts/R/shell/streamtos3',
    dag=dag
)


task_2 = BashOperator(
    task_id='refresh_mat_submissions_by_second',
    bash_command='. /home/scripts/R/shell/refresh_mat_submissions_by_second',
    dag=dag
)

task_3 = BashOperator(
    task_id='refresh_mat_comments_by_second',
    bash_command='. /home/scripts/R/shell/refresh_mat_comments_by_second',
    dag=dag
)

task_0 >> task_1
task_1 >> task_2
task_2 >> task_3
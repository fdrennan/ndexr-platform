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
    bash_command='. /home/scripts/R/shell/backup_postgres_to_s3',
    dag=dag
)


task_3 = BashOperator(
    task_id='transfer_submission_from_s3_to_postgres',
    bash_command='. /home/scripts/R/shell/transfer_submission_from_s3_to_postgres',
    dag=dag
)

task_4 = BashOperator(
    task_id='refresh_mat_submission_summary',
    bash_command='. /home/scripts/R/shell/refresh_mat_submission_summary',
    dag=dag
)

task_5 = BashOperator(
    task_id='refresh_urls_count_by_day',
    bash_command='. /home/scripts/R/shell/refresh_urls_count_by_day',
    dag=dag
)

task_6 = BashOperator(
    task_id='refresh_mat_meta_statistics_poweredge',
    bash_command='. /home/scripts/R/shell/refresh_mat_meta_statistics_poweredge',
    dag=dag
)
task_1 >> task_2
task_2 >> task_3
task_3 >> task_4
task_3 >> task_5
task_3 >> task_6

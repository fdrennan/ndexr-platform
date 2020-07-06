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

dag = DAG(dag_id='daily_ndexr',
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

task_11 = BashOperator(
    task_id='update_costs',
    bash_command='. /home/scripts/R/shell/update_costs',
    dag=dag
)

task_2 = BashOperator(
    task_id='backup_postgres_to_s3_xps',
    bash_command='. /home/scripts/R/shell/backup_postgres_to_s3',
    dag=dag
)


task_3 = BashOperator(
    task_id='transfer_submission_from_s3_to_postgres_poweredge',
    bash_command='. /home/scripts/R/shell/transfer_submission_from_s3_to_postgres',
    dag=dag
)

task_4 = BashOperator(
    task_id='refresh_mat_author_summary_poweredge',
    bash_command='. /home/scripts/R/shell/refresh_mat_author_summary',
    dag=dag
)

task_9 = BashOperator(
    task_id='refresh_mat_subreddit_summary_poweredge',
    bash_command='. /home/scripts/R/shell/refresh_mat_subreddit_summary',
    dag=dag
)

task_5 = BashOperator(
    task_id='refresh_mat_urls_summary_poweredge',
    bash_command='. /home/scripts/R/shell/refresh_urls_summary',
    dag=dag
)

task_10 = BashOperator(
    task_id='refresh_mat_urls_summary_day_poweredge',
    bash_command='. /home/scripts/R/shell/refresh_urls_summary_day',
    dag=dag
)

task_6 = BashOperator(
    task_id='refresh_mat_meta_statistics_poweredge',
    bash_command='. /home/scripts/R/shell/refresh_mat_meta_statistics_poweredge',
    dag=dag
)

task_7 = BashOperator(
    task_id='poweredge_to_xps_meta_statistics',
    bash_command='. /home/scripts/R/shell/poweredge_to_xps_meta_statistics',
    dag=dag
)

task_8 = BashOperator(
    task_id='upload_submissions_to_elastic',
    bash_command='. /home/scripts/R/shell/upload_submissions_to_elastic',
    dag=dag
)



task_1 >> task_2
task_1 >> task_11
task_2 >> task_3
task_3 >> task_4
task_3 >> task_5
task_3 >> task_10
task_3 >> task_6
task_3 >> task_8
task_3 >> task_9
task_6 >> task_7

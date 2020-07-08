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
dag = DAG(dag_id='postgres_refresh',
          default_args=args,
          schedule_interval='*/10 * * * *',
          concurrency=1,
          max_active_runs=1,
          catchup=False)

task = BashOperator(
    task_id='aws_configure',
    bash_command='. /home/scripts/R/shell/aws_configure',
    dag=dag
)

task_0 = BashOperator(
    task_id='build_tables',
    bash_command='. /home/scripts/R/shell/build_tables',
    dag=dag
)

task_1 = BashOperator(
    task_id='refresh_mat_counts_by_second',
    bash_command='. /home/scripts/R/shell/refresh_mat_counts_by_second',
    dag=dag
)

task_2 = BashOperator(
    task_id='refresh_mat_counts_by_minute',
    bash_command='. /home/scripts/R/shell/refresh_mat_counts_by_minute',
    dag=dag
)

task_3 = BashOperator(
    task_id='refresh_mat_meta_statistics',
    bash_command='. /home/scripts/R/shell/refresh_mat_meta_statistics',
    dag=dag
)


task   >> task_0
task_0 >> task_1
task_0 >> task_2
task_0 >> task_3

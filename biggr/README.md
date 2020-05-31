# INSTALLATION

aws ec2 create-default-vpc


Technical documentation is not complete but is located [here](https://fdrennan.github.io/biggr_book/).

![](https://travis-ci.org/fdrennan/awsR.svg?branch=master)
[![codecov](https://codecov.io/gh/fdrennan/biggr/branch/master/graph/badge.svg)](https://codecov.io/gh/fdrennan/biggr)

To get the package on your computer, run the following command. I would recommend that only experienced AWS users use this package at this time. When I update the technical documentation, it will be easier for new people to use.


```{r}
devtools::install_github("fdrennan/biggr")
```

Once installed, run the following.
```{r}
library(biggr)
install_python() # Only need to once
configure_aws(
          aws_access_key_id     = Sys.getenv('AWS_ACCESS'),
          aws_secret_access_key = Sys.getenv('AWS_SECRET'),
          default.region        = Sys.getenv('AWS_REGION')
)
```

## Costs

It is important to monitor your costs. Today's costs do not show up immediately. Be careful and always have to option to close down servers in the AWS UI.

```{r}
cost_get(from = '2019-04-25', to = '2019-04-28')
```

```
# A tibble: 3 x 4
  start      unblended_cost blended_cost usage_quantity
  <chr>               <dbl>        <dbl>          <dbl>
1 2019-04-25           1.41         1.41           457.
2 2019-04-26           1.36         1.36           497.
3 2019-04-27           1.99         1.99           548.
```

## EC2

First, if you haven't created a key pair run the following commands. The keyfile will automatically be added to your working directory.

```{r}
key_pair <- keyfile_create(keyname = 'mykeypair')
print(key_pair)
```

Now you're ready to create a server. 
```{r}
server <- 
    ec2_instance_create(ImageId = 'ami-0c55b159cbfafe1f0',
                        KeyName = 'mykeypair',
                        InstanceType = 't2.medium',
                        InstanceStorage = 50,
                        SecurityGroupId = 'sg-0e8841d7a144aa628')
```

Get the most recent server data 
```{r}
ec2_info <- ec2_get_info() %>% 
  filter(instance_id == server[[1]]$id) 
```

Check out the ec2_instance data
```{r}
glimpse(ec2_info)
```

```
Observations: 1
Variables: 7
$ public_ip_address   <chr> "18.188.56.181"
$ priviate_ip_address <chr> "172.31.12.87"
$ image_id            <chr> "ami-0c55b159cbfafe1f0"
$ instance_id         <chr> "i-09a9ffcc5d1dc9af1"
$ launch_time         <dttm> 2019-05-03 05:43:41
$ instance_type       <chr> "t2.medium"
$ state               <chr> "running"
```

Terminate the instance
```{r}
ec2_instance_stop(ids = ec2_info$instance_id, terminate = TRUE)
```

Modify the instance
```{r}
ec2_instance_modify(instance_id = ec2_info$instance_id,
                    value       = 't2.small')
```

Start the instance
```{r}
ec2_instance_start(ec2_info$instance_id)
```


## S3

Create a bucket using `s3_create_bucket`

```{r}
s3_create_bucket(
  bucket_name = 'freddydbucket', 
  location = 'us-east-2'
)
```

```
[1] "http://freddydbucket.s3.amazonaws.com/"
```

Upload a file using `s3_upload_file`
```{r}
s3_upload_file(
    bucket = 'freddydbucket', 
    from = 'NAMESPACE', 
    to = 'uploaded_NAMESPACE',
    make_public = TRUE
)
```

```
You may need to change the region in the url
https://s3.us-east-2.amazonaws.com/freddydbucket/uploaded_NAMESPACE
[1] "https://s3.us-east-2.amazonaws.com/freddydbucket/uploaded_NAMESPACE"
```

Download a file using `s3_download_file`
```{r}
s3_download_file(
    bucket = 'freddydbucket', 
    from = 'uploaded_NAMESPACE', 
    to = 'downloaded_NAMESPACE'
)
```

Get buckets
```{r}
s3_list_buckets()
```

```
 A tibble: 5 x 2
  name                     creation_date            
  <chr>                    <chr>                    
1 couch-dog-photos         2019-03-08 04:45:05+00:00
2 fdrennantestbucket844445 2019-05-02 23:44:09+00:00
3 fdrennanunittest         2019-05-02 21:15:04+00:00
4 freddydbucket            2019-05-03 05:46:19+00:00
5 kerasmods                2019-01-29 20:47:11+00:00
```

Delete Bucket
```{r}
s3_delete_bucket('fdrennantestbucket844445')
```

```
[1] TRUE
```

Get objects in a bucket
```{r}
s3_list_objects('kerasmods')
```

```
              key   size                               etag storage_class
1           data1      5 "89d903bc35dede724fd52c51437ff5fd"      STANDARD
2       ex-sync.R      0 "d41d8cd98f00b204e9800998ecf8427e"      STANDARD
3      model.hdf5 780504 "28527b706de60289e5b9ec6b67b67a1a"      STANDARD
4 number_data.txt 519638 "e9157d53258f3f4a3459f421fec4ad2e"      STANDARD
                                                          owner_id
1 f5ac91d6b469e68df6c3dd63bb4fa514c940fe9592974de874d71355978ce9f9
2 f5ac91d6b469e68df6c3dd63bb4fa514c940fe9592974de874d71355978ce9f9
3 f5ac91d6b469e68df6c3dd63bb4fa514c940fe9592974de874d71355978ce9f9
4 f5ac91d6b469e68df6c3dd63bb4fa514c940fe9592974de874d71355978ce9f9
              last_modified
1 2019-01-30 09:05:19+00:00
2 2019-01-30 09:03:00+00:00
3 2019-01-30 09:14:16+00:00
4 2019-01-30 15:34:04+00:00
```

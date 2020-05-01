# library(biggr)
#
#
# client = boto3()$client('cognito-idp')
#
# # client$list_identities(IdentityPoolId = "us-east-2:5a3f074c-ad2f-4b41-8d33-79ecdb5c9f26",
# #                        MaxResults = 1L)
#
# users <- client$list_users(UserPoolId = Sys.getenv('USER_POOL_ID'))
#
#
# map_df(
#   users$Users,
#   function(x) {
#     tibble(
#       username = x$Username,
#       user_status = x$UserStatus,
#       email = x$Attributes[[3]]$Value
#     )
#   }
# )
#
#

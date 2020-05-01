#' sns_send_message
#' @param phone_number  Recipient phone number
#' @param message  Recipient message
#' @param region  Region to send the message from
#' @param message_aws  Return AWS data or TRUE
#' @export sns_send_message
sns_send_message <- function(phone_number = NA,
                             message = "Hello World!",
                             region = "us-east-1",
                             message_aws = FALSE) {
  client <- client_sns(region=region)
  phone_number <- paste0("+", phone_number)
  response <- client$publish(
    PhoneNumber = phone_number,
    Message     = message
  )
  if(message_aws) {
    return(response)
  } else {
    return(TRUE)
  }
}


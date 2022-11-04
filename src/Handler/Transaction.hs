module Handler.Transaction where

import Import

postTransactionR :: Handler Value
postTransactionR = do
  -- requireCheckJsonBody will parse the request body into the appropriate type, or return a 400 status code if the request JSON is invalid.
  -- (The ToJSON and FromJSON instances are derived in the config/models file).
  transaction <- (requireCheckJsonBody :: Handler Transaction)

  -- The YesodAuth instance in Foundation.hs defines the UserId to be the type used for authentication.
  maybeCurrentUserId <- maybeAuthId
  let transaction' = transaction {transactionUserId = maybeCurrentUserId}

  insertedTransaction <- runDB $ insertEntity transaction'
  returnJson insertedTransaction

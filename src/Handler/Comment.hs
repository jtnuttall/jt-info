module Handler.Comment where

import Import

postCommentR :: Handler Value
postCommentR = do
    -- requireJsonBody will parse the request body into the appropriate type, or return a 400 status code if the request JSON is invalid.
    -- (The ToJSON and FromJSON instances are derived in the config/models file).
    comment <- (requireJsonBody :: Handler Comment)

    -- The YesodAuth instance in Foundation.hs defines the UserId to be the type used for authentication.
    maybeEitherCurrentUserId <- maybeAuthId
    let maybeCurrentUserId = 
            case maybeEitherCurrentUserId of
                Just eitherCurrentUserId ->
                    case eitherCurrentUserId of 
                        Left userid -> Just userid
                        Right _     -> Nothing
                Nothing -> Nothing

    let comment' = comment { commentUserId = maybeCurrentUserId }

    insertedComment <- runDB $ insertEntity comment'
    returnJson insertedComment

{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Profile where

import Import

getProfileR :: Handler Html
getProfileR = do
    (_, eitherUser) <- requireAuthPair

    defaultLayout $ do
        let username = 
                case eitherUser of
                    Left user     -> userIdent user
                    Right manager -> managerName manager <> " (manager)"
              
        setTitle . toHtml $ username <> "'s User page"
        
        $(widgetFile "profile")

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Handler.About where

import Import

getAboutR :: Handler Html
getAboutR = do
    defaultLayout $ do
        setTitle "James Thomas — About"
        $(widgetFile "about")

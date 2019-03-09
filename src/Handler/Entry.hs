{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
module Handler.Entry where

import Import
import Text.Blaze.Html
import Data.Time.Clock
import Data.Time.Format

getEntryR :: EntryId -> Handler Html
getEntryR entryId = do
    Entry{..} <- runDB $ get404 entryId

    let linkToEntry = False
    loggedIn <- isJust <$> maybeAuthPair
    
    defaultLayout $ do
        setTitle $ toHtml $ entryTitle <> " — James Thomas' Blog"
        $(widgetFile "entry/entry")

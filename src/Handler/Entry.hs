{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
module Handler.Entry where

import Import
import Text.Blaze.Html
import Data.Time.Clock
import Data.Time.Format

--construct a widget from an entry entity
--entrycontents are raw html...usually dangerous but this is only going
--to come from my account. it is not user-generated 
getEntryWidget :: Entry -> WidgetFor App () 
getEntryWidget Entry{..} = 
    let maybeEntryId = Nothing
    in $(widgetFile "entry/entry")

getEntryR :: EntryId -> Handler Html
getEntryR entryId = do
    entry <- runDB $ get404 entryId
    
    defaultLayout $ do
        setTitle $ toHtml $ entryTitle entry <> " — James Thomas' Blog"
        getEntryWidget entry

{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE QuasiQuotes #-}
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
getEntryWidget Entry{..} = toWidget 
    [hamlet|
          <div .row>
              <h2>#{entryTitle}
          <div .row>#{preEscapedToHtml entryContents}
          <div .float-right>#{formatTime defaultTimeLocale "%R — %u, %B %Y" entryPosted}
          <hr>
    |]

getEntryR :: EntryId -> Handler Html
getEntryR entryId = do
    entry <- runDB $ get404 entryId
    
    defaultLayout $ do
        setTitle $ toHtml $ entryTitle entry <> "— James Thomas' Blog"
        getEntryWidget entry

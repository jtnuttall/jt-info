{-# LANGUAGE TemplateHaskell #-}
module Handler.EditEntry where

import Import

getEditEntryR :: EntryId -> Handler Html
getEditEntryR entryId = error "Not yet implemented: getEditEntryR"

--do
  --  entry <- get entryId
    
  --  let postRoute = EditEntryR
  --      maybeKey = Nothing

 --   defaultLayout $ do
  --      $(widgetFile "entry/new")

postEditEntryR :: EntryId -> Handler Html
postEditEntryR entryId = error "Not yet implemented: postEditEntryR"

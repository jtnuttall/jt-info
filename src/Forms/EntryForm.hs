{-# LANGUAGE OverloadedStrings #-}
module Forms.EntryForm where

import Import
import Plugins.Summernote
import Yesod.Form.Bootstrap3

data EntryForm = EntryForm
    { title :: Text
    , contents :: Html
    }

entryForm :: Maybe Entry -> Form EntryForm
entryForm mentry = renderBootstrap3 BootstrapBasicForm $ EntryForm
    <$> areq textField (bfs ("Title" :: Text)) (entryTitle <$> mentry)
    <*> areq (snHtmlFieldCustomized "{height: 500}") "Contents" (entryContents <$> mentry)

entryFormIds :: (Text, Text, Text)
entryFormIds =
  ( "js-entryFormId"
  , "js-entryStatusId"
  , "js-entryTitleId"
  )



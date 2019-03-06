{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module Handler.NewEntry where

import Import
import Text.Julius (RawJS(..))
import Yesod.Form.Bootstrap3
import Plugins.Summernote
import Data.Time.Clock (getCurrentTime)

data EntryForm = EntryForm
    { title :: Text
    , contents :: Html
    }

entryForm :: Form EntryForm
entryForm = renderBootstrap3 BootstrapBasicForm $ EntryForm
    <$> areq textField (bfs ("Title" :: Text)) Nothing
    <*> areq (snHtmlFieldCustomized "{height: 500}") "Contents" Nothing

pageIds :: (Text, Text, Text)
pageIds =
  ( "js-entryFormId"
  , "js-entryStatusId"
  , "js-entryTitleId"
  )

getNewEntryR :: Handler Html
getNewEntryR = do
    let maybeKey = Nothing

    (editorWidget, enctype) <- generateFormPost entryForm

    defaultLayout $ do
        setTitle "New Blog Entry"

        --addStylesheet $ StaticR quill_quill_snow_css
        --addScript $ StaticR quill_quill_min_js
        --addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.7.1/katex.min.js"
        --addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js"

        let ( entryFormId
             , entryStatusId
             , entryTitleId
             ) = pageIds

        $(widgetFile "entry/new")

postNewEntryR :: Handler Html
postNewEntryR = do
    ((result, editorWidget), enctype) <- runFormPost entryForm

    maybeKey <- case result of
        FormSuccess (EntryForm{..}) -> do
            time <- liftIO getCurrentTime
            key  <- runDB $ insert $ Entry title contents time
            return $ Just key
        _ -> return $ Nothing

    defaultLayout $ do
        setTitle "New Blog Entry -- Posted!"

        let ( entryFormId
             , entryStatusId
             , entryTitleId
             ) = pageIds

        $(widgetFile "entry/new")

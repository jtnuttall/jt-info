{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
module Handler.NewEntry where

import Import
import Text.Julius (RawJS(..))
import Yesod.Form.Bootstrap3
import Plugins.Summernote

data EntryForm = EntryForm
    { title :: Html
    , contents :: Html
    }

entryForm :: Form EntryForm
entryForm = renderBootstrap3 BootstrapBasicForm $ EntryForm
    <$> areq (snHtmlFieldCustomized "{toolbar:false}") "Title" Nothing
    <*> areq snHtmlField "Contents" Nothing

pageIds :: (Text, Text, Text, Text, Text, Text)
pageIds =
  ( "js-standaloneContainerId"
  , "js-toolbarContainerId"
  , "js-quillAreaId"
  , "js-entryFormId"
  , "js-entryStatusId"
  , "js-entryTitleId"
  )

getNewEntryR :: Handler Html
getNewEntryR = do
    let placeholder = "contents..." :: Text

    (editorWidget, enctype) <- generateFormPost entryForm

    defaultLayout $ do
        setTitle "New Blog Entry"

        --addStylesheet $ StaticR quill_quill_snow_css
        --addScript $ StaticR quill_quill_min_js
        --addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.7.1/katex.min.js"
        --addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js"

        let ( standaloneContainerId
              , toolbarContainerId
              , quillAreaId
              , entryFormId
              , entryStatusId
              , entryTitleId
              ) = pageIds

        $(widgetFile "entry/new")

postNewEntryR :: Handler Html
postNewEntryR = error "Not yet implemented: postNewEntryR"

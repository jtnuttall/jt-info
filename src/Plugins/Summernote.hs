-- | Provide the user with the Summernote rich text editor.
--
-- /NOTES:/
--
-- Editor fields have hidden textareas which are updated automatically when
-- editor contents changes.
--
-- @
-- summerForm :: Form HtmlComment
-- summerForm = renderBootstrap3 BootstrapBasicForm $ HtmlComment
--   \<$\> areq (snHtmlFieldCustomized "{toolbar:false}") \"Title\" Nothing
--   \<*\> areq snHtmlField \"Comment\" Nothing
--
-- Edited for Yesod 1.6 by Jeremy Nuttall
-- @
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}
module Plugins.Summernote
    ( YesodSummernote (..)
    , snHtmlFieldCustomized
    , snHtmlField
    ) where

import           Control.Monad                   (when)
import           Data.Maybe                      (listToMaybe)
import           Data.Text                       (Text, pack)
import           Text.Blaze.Html.Renderer.String (renderHtml)
import           Text.Hamlet                     (shamlet)
import           Text.HTML.SanitizeXSS           (sanitizeBalance)
import           Text.Julius                     (julius, rawJS)
import           Yesod.Core
import           Yesod.Form

class Yesod a => YesodSummernote a where
    -- | Bootstrap 3 CSS location.
    urlBootstrapCss :: a -> Maybe (Either (Route a) Text)
    urlBootstrapCss _ = Just $ Right
        "http://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.css"
    -- | Bootstrap 3 library location.
    urlBootstrapScript :: a -> Maybe (Either (Route a) Text)
    urlBootstrapScript _ = Just $ Right
        "http://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.js"
    -- | JQuery library location.
    urlJQueryScript :: a -> Maybe (Either (Route a) Text)
    urlJQueryScript _ = Just $ Right
        "http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"
    -- | Summernote Editor CSS location.
    urlSummernoteCss :: a -> Maybe (Either (Route a) Text)
    urlSummernoteCss _ = Just $ Right
        "http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.11/summernote.css"
    -- | Summernote Editor library location.
    urlSummernoteScript :: a -> Maybe (Either (Route a) Text)
    urlSummernoteScript _ = Just $ Right
        "http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.11/summernote.js"
    -- | Should required libraries and scripts be added in DOM tree?  This
    -- property required to control script loading.  In case if you load JQuery,
    -- Bootstrap, and Summernote libraries and CSS in @<head>@ it is not
    -- necessary to load them second time, moreover this could bring some
    -- issues, for example if JQuery is loaded second time it could brake AJAX
    -- configuration from 'defaultCsrfMiddleware'.  Setting this to @True@ could
    -- be useful in case you need single instance of editor on some pages only.
    summernoteLoadLibrariesAndCss :: a -> Bool
    summernoteLoadLibrariesAndCss _ = False

-- | Customizable Summernote editor field.
--
-- @cfg@ argument should be a JSON formatted string, it will be passed to
-- @$.summernote()@ call as first argument.
--
-- @
-- snHtmlFieldCustomized "{ height: 150, codemirror: { theme:'monokai' } }"
-- @
snHtmlFieldCustomized :: (YesodSummernote site)
                      => String
                      -> Field (HandlerFor site) Html
snHtmlFieldCustomized cfg = Field
    { fieldParse =
        \e _ -> return $
            Right . fmap (preEscapedToMarkup . sanitizeBalance) . listToMaybe $ e
    , fieldView = \theId name attrs val _isReq -> do
        toWidget [shamlet|
                    $newline never
                    <textarea id="#{theId}" *{attrs} name="#{name}" .html>#{showVal val}
                  |]

        master <- getYesod

        (when (summernoteLoadLibrariesAndCss master) $ do
            addScript'     urlJQueryScript
            addStylesheet' urlBootstrapCss
            addScript'     urlBootstrapScript
            addStylesheet' urlSummernoteCss
            addScript'     urlSummernoteScript
            )
        toWidget $ [julius|
            $(document).ready(function(){
              var input = document.getElementById("#{rawJS theId}");
              $(input).summernote(#{rawJS cfg}).on('summernote.change',function(){
                $(input).text($(input).summernote('code'));
              });
            });
            |]
    , fieldEnctype = UrlEncoded
    }
  where
    showVal = either id (pack . renderHtml)

-- | Summernote editor field with default settings.
snHtmlField :: YesodSummernote site
            => Field (HandlerFor site) Html
snHtmlField = snHtmlFieldCustomized ""

addScript' :: (MonadWidget m, HandlerSite m ~ site)
           => (site -> Maybe (Either (Route site) Text))
           -> m ()
addScript' f = do
    y <- getYesod

    case f y of
        Just z  -> addScriptEither z
        Nothing -> return ()

addStylesheet' :: (MonadWidget m, HandlerSite m ~ site)
               => (site -> Maybe (Either (Route site) Text))
               -> m ()
addStylesheet' f = do
    y <- getYesod

    case f y of
        Just z  -> addStylesheetEither z
        Nothing -> return ()

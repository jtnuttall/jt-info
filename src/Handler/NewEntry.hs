{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module Handler.NewEntry where

import Import
import Text.Julius (RawJS(..))
import Forms.EntryForm
import Data.Time.Clock (getCurrentTime)
import Database.Persist.Sql (fromSqlKey)

getNewEntryR :: Handler Html
getNewEntryR = do
    let postRoute = NewEntryR
        maybeKey = Nothing
        pageTitle = "New Post!" :: Text

    (editorWidget, enctype) <- generateFormPost (entryForm Nothing)

    defaultLayout $ do
        setTitle "New Blog Entry"

        let ( entryFormId
             , entryStatusId
             , entryTitleId
             ) = entryFormIds

        $(widgetFile "entry/editor")

postNewEntryR :: Handler Html
postNewEntryR = do
    let postRoute = NewEntryR
        pageTitle = "New Post!" :: Text

    ((result, editorWidget), enctype) <- runFormPost (entryForm Nothing)

    maybeKey <- case result of
        FormSuccess EntryForm{..} -> do
            time <- liftIO getCurrentTime
            key  <- runDB $ insert $ Entry title contents time Nothing
            return $ Just key
        _ -> return $ Nothing

    defaultLayout $ do
        setTitle "New Blog Entry -- Posted!"

        let ( entryFormId
             , entryStatusId
             , entryTitleId
             ) = entryFormIds

        $(widgetFile "entry/editor")

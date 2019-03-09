{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecordWildCards #-}
module Handler.Home where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)
import Yesod.Paginator
import Text.Blaze.Html
import Data.Time.Clock
import Data.Time.Format
import Data.Maybe (isJust)

--construct a widget from an entry entity
--entrycontents are raw html...usually dangerous but this is only going
--to come from my account. it is not user-generated 
getEntryWidget :: Bool -> Entity Entry -> WidgetFor App () 
getEntryWidget loggedIn entity =
    let linkToEntry = True
        entryId     = entityKey entity
        Entry{..}   = entityVal entity
    in $(widgetFile "entry/entry")

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler Html
getHomeR = do
    entries <- runDB $ selectList [] [Desc EntryId]
    loggedIn <- isJust <$> maybeAuthPair :: Handler Bool
    let entries' = map (getEntryWidget loggedIn) entries
    pages <- paginate 3 entries'

    defaultLayout $ do
        aDomId <- newIdent
        setTitle "James Thomas"
        $(widgetFile "homepage")


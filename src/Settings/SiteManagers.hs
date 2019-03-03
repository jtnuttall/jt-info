{-# LANGUAGE OverloadedStrings #-}
module Settings.SiteManagers where

import Data.List (find)
import Data.Text (Text)

data SiteManager = SiteManager
  { managerName :: Text
  , managerPass :: Text
  } deriving (Show)

siteManagers :: [SiteManager]
siteManagers =
  [ SiteManager "james" "WHAT\"LL it BE?"
  ]

lookupUser :: Text -> Maybe SiteManager
lookupUser username = find (\m -> managerName m == username) siteManagers

validPassword :: Text -> Text -> Bool
validPassword u p =
  case find (\m -> managerName m == u && managerPass m == p) siteManagers of
    Just _ -> True
    _      -> False

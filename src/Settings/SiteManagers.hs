{-# LANGUAGE OverloadedStrings #-}
module Settings.SiteManagers where

import Import

data SiteManager = SiteManager
  { managerName :: Text
  , managerPass :: Text
  } deriving (Show)

siteManagers :: [SiteManager]
siteManagers =
  [ SiteManager "james" "WHAT\"LL it BE?"
  ]

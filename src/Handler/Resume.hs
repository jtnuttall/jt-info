{-# LANGUAGE QuasiQuotes #-}
module Handler.Resume where

import Import

getResumeR :: Handler Html
getResumeR = do
    defaultLayout $ toWidget
        [hamlet|
            <iframe src="https://drive.google.com/file/d/1sCFPChW_GqxIx287m3dI4dmsw3q410TN/preview"
            height="600" style="width:100%">
        |]

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE ImplicitParams #-}

import qualified GI.Gtk as Gtk
import qualified GI.Adw as Adw
import Data.GI.Base
import Data.Text (Text)
import qualified Data.Text as T
import Data.Char (isDigit, isLower, isUpper)
import System.Random (randomRIO)
import Control.Monad (replicateM, void)
import System.Environment (getArgs, getProgName)

charset :: String
charset = ['a'..'z'] ++ ['A'..'Z'] ++ ['0'..'9'] ++ "!@#$%^&*_+-"

generatePassword :: Int -> IO Text
generatePassword len = do
  idxs <- replicateM len (randomRIO (0, length charset - 1))
  return $ T.pack [charset !! i | i <- idxs]

passwordStrength :: Text -> (Text, String)
passwordStrength pwd
  | len < 8   = ("Слабый", "red")
  | len < 12  = ("Средний", "orange")
  | hasUpper && hasLower && hasDigit && hasSpecial = ("Сильный", "green")
  | otherwise = ("Средний", "orange")
  where
    len = T.length pwd
    hasUpper = T.any isUpper pwd
    hasLower = T.any isLower pwd
    hasDigit = T.any isDigit pwd
    hasSpecial = T.any (`elem` ("!@#$%^&*_+-" :: String)) pwd

activate :: Adw.Application -> IO ()
activate app = do
  content <- new Gtk.Box
    [ #orientation := Gtk.OrientationVertical
    , #spacing := 12
    , #marginStart := 20
    , #marginEnd := 20
    , #marginTop := 20
    , #marginBottom := 20
    ]

  lenLabel <- new Gtk.Label [#label := "Длина пароля: 12"]
  adjustment <- new Gtk.Adjustment [#value := 12, #lower := 8, #upper := 64, #stepIncrement := 1]
  scale <- new Gtk.Scale [#orientation := Gtk.OrientationHorizontal, #adjustment := adjustment]
  scale.setDigits 0
  content.append lenLabel
  content.append scale

  result <- new Gtk.Entry [#editable := False, #placeholderText := "Здесь появится пароль"]
  content.append result

  strengthLabel <- new Gtk.Label [#label := ""]
  content.append strengthLabel

  generateBtn <- new Gtk.Button [#label := "Сгенерировать 🔐"]
  content.append generateBtn

  on scale #valueChanged $ do
    val <- round <$> scale.getValue
    lenLabel.setLabel $ "Длина пароля: " <> T.pack (show val)

  let updatePassword = do
        len <- round <$> scale.getValue
        pwd <- generatePassword len
        result.setText pwd
        let (strText, color) = passwordStrength pwd
        strengthLabel.setMarkup $ "<span foreground=\"" <> T.pack color <> "\">" <> strText <> "</span>"

  on generateBtn #clicked updatePassword

  window <- new Adw.ApplicationWindow
    [ #application := app
    , #defaultWidth := 400
    , #defaultHeight := 280
    , #content := content
    ]

  window.setTitle (Just (T.pack "Генератор паролей"))

  window.present

main :: IO ()
main = do
  app <- new Adw.Application
    [ #applicationId := "haskell.password.generator"
    , On #activate (activate ?self)
    ]
  args <- getArgs
  progName <- getProgName
  void $ app.run (Just (progName : args))

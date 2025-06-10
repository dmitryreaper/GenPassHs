
{-# LANGUAGE OverloadedStrings, OverloadedLabels #-}

import qualified GI.Gtk as Gtk
import Data.GI.Base

main :: IO ()
main = do
  Gtk.init Nothing

  win <- new Gtk.Window [ #title := "First app" ]

  on win #destroy Gtk.mainQuit

  button <- new Gtk.Button [ #label := "Нажми сюда" ]

  on button #clicked (set button [ #sensitive := True,
                                   #label := "Спасибо за нажатие" ])

  #add win button

  #showAll win

  Gtk.main

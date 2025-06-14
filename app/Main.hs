{-# LANGUAGE OverloadedStrings, OverloadedLabels #-}
import qualified GI.Gtk as Gtk
import Data.GI.Base
import Data.IORef
import Control.Monad.IO.Class (liftIO)

main :: IO ()
main = do
  -- Инициализация GTK
  Gtk.init Nothing

  -- Создание окна
  win <- new Gtk.Window [ #title := "First app" ]
  on win #destroy Gtk.mainQuit

  -- Создание контейнера (вертикального Box)
  box <- new Gtk.Box [ #orientation := Gtk.OrientationVertical, #spacing := 5 ]

  labelHello <- new Gtk.Label [ #label := "Привет от Haskell!" ]


  -- Первая кнопка
  button <- new Gtk.Button [ #label := "Нажми сюда" ]
  on button #clicked $ set button [ #label := "Спасибо за нажатие" ]

  -- Вторая кнопка
  buttona <- new Gtk.Button [ #label := "Button" ]
  on buttona #clicked $ set buttona [ #label := "Спасибо за нажатие" ]

  -- === Метка 2: Счётчик нажатий ===
  clickCountRef <- newIORef (0 :: Int)
  labelCounter <- new Gtk.Label [ #label := "Количество нажатий: 0" ]

  let updateCounter = do
        modifyIORef' clickCountRef (+1)
        count <- readIORef clickCountRef
        set labelCounter [ #label := "Количество нажатий: "]
  
  on button #clicked updateCounter
  on buttona #clicked updateCounter

  -- Добавляем кнопки в контейнер
  #add box labelCounter
  #add box labelHello  
  #add box button
  #add box buttona

  -- Добавляем контейнер в окно
  #add win box

  -- Отображаем все элементы
  Gtk.widgetShowAll win

  -- Запуск главного цикла GTK
  Gtk.main

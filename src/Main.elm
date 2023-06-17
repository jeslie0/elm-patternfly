port module Main exposing (..)

import Browser
import Components.Button exposing (..)
import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import List exposing (..)



-- * Ports


port consoleLog : String -> Cmd msg



-- * MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = viewDocument
        , update = update
        , subscriptions = subscriptions
        }



-- * MODEL


type alias Model =
    { isLoading : Bool
    , text : String
    }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { isLoading = False, text = "Click to start loading" }
    , Cmd.none
    )



-- * UPDATE


type Msg
    = Foo


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Foo ->
            ( if model.isLoading then
                { isLoading = False, text = "Click to start loading" }

              else
                { isLoading = True, text = "Click to stop loading" }
            , consoleLog "Hello, Foo!"
            )



-- * SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- * VIEW


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = ""
    , body = [ view model ]
    }


view : Model -> Html Msg
view model =
    H.div
        []
        [ H.button [ HA.classList [ ( "pf-c-button", True ), ( "pf-m-primary", True ) ] ] [ H.text "Primary" ]
        , (button
            |> withVariant Primary
            |> (withIsLoading <| Just model.isLoading)
            |> withBadgeCount (Just { className = "", count = 7, isRead = True })
            |> withComponent (\attributes children -> H.a (HA.href "http://elm-lang.org" :: attributes) children)
            |> withIsActive True
            |> toHtml
          )
            [ HE.onClick Foo ]
            [ H.text model.text ]
        ]


type Button
    = Button String String


reverse : List a -> List a
reverse list =
    case list of
        [] ->
            []

        x :: xs ->
            reverse xs ++ [ x ]

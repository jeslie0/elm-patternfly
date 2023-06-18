port module Main exposing (..)

import Browser
import Components.Accordion as Accordion
import Components.Accordion.Content as AccordionContent
import Components.Accordion.Toggle as AccordionToggle
import Components.Accordion.Types exposing (..)
import Html as H exposing (Html)
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
        [ HE.onClick Foo ]
        [ Accordion.default
            |> Accordion.withAccordionItem
                { toggle =
                    AccordionToggle.default "foo"
                        |> AccordionToggle.withExpanded (not model.isLoading)
                        |> AccordionToggle.withChild (H.text "Item one")
                , content =
                    AccordionContent.default
                        |> AccordionContent.withHidden model.isLoading
                        |> AccordionContent.withChild (H.p [] [ H.text "Body content!" ])
                }
            |> Accordion.withAccordionItem
                { toggle =
                    AccordionToggle.default "bar"
                        |> AccordionToggle.withExpanded (model.isLoading)
                        |> AccordionToggle.withChild (H.text "Item two")
                , content =
                    AccordionContent.default
                        |> AccordionContent.withHidden (not model.isLoading)
                        |> AccordionContent.withChild (H.p [] [ H.text "Body content!" ])
                }

            |> Accordion.withHeadingLevel H1
            |> Accordion.toHtml
        ]


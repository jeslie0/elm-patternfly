module Accordion.Main exposing (..)

import Browser exposing (document)
import Components.Accordion as Accordion
import Components.Accordion.Content as AccordionContent
import Components.Accordion.Item as AccordionItem
import Components.Accordion.Toggle as AccordionToggle
import Components.Accordion.Types exposing (..)
import Html as H exposing (Html)
import Html.Events as HE
import List exposing (..)



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
    String


init : flags -> ( Model, Cmd Msg )
init _ =
    ( ""
    , Cmd.none
    )



-- * UPDATE


type Msg
    = Update String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update str ->
            ( str, Cmd.none )



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


onToggle : Model -> String -> Msg
onToggle model str =
    if str == model then
        Update ""

    else
        Update str


view : Model -> Html Msg
view model =
    H.div
        []
        [ Accordion.default
            |> Accordion.withAccordionItem
                (AccordionItem.default
                    |> AccordionItem.withToggle
                        (AccordionToggle.default "firsttoggle"
                            |> AccordionToggle.withChild (H.text "Item one")
                            |> AccordionToggle.withExpanded (model == "firsttoggle")
                            |> AccordionToggle.withAttribute (HE.onClick <| onToggle model "firsttoggle")
                        )
                    |> AccordionItem.withContent
                        (AccordionContent.default
                            |> AccordionContent.withHidden (model /= "firsttoggle")
                            |> AccordionContent.withChild (H.text "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                        )
                )
            |> Accordion.withAccordionItem
                (AccordionItem.default
                    |> AccordionItem.withToggle
                        (AccordionToggle.default "secondtoggle"
                            |> AccordionToggle.withChild (H.text "Item two")
                            |> AccordionToggle.withExpanded (model == "secondtoggle")
                            |> AccordionToggle.withAttribute (HE.onClick <| onToggle model "secondtoggle")
                        )
                    |> AccordionItem.withContent
                        (AccordionContent.default
                            |> AccordionContent.withHidden (model /= "secondtoggle")
                            |> AccordionContent.withChild (H.text "Vivamus et tortor sed arcu congue vehicula eget et diam. Praesent nec dictum lorem. Aliquam id diam ultrices, faucibus erat id, maximus nunc.")
                        )
                )
            |> Accordion.withAccordionItem
                (AccordionItem.default
                    |> AccordionItem.withToggle
                        (AccordionToggle.default "thirdtoggle"
                            |> AccordionToggle.withChild (H.text "Item three")
                            |> AccordionToggle.withExpanded (model == "thirdtoggle")
                            |> AccordionToggle.withAttribute (HE.onClick <| onToggle model "thirdtoggle")
                        )
                    |> AccordionItem.withContent
                        (AccordionContent.default
                            |> AccordionContent.withHidden (model /= "thirdtoggle")
                            |> AccordionContent.withChild (H.text "Morbi vitae urna quis nunc convallis hendrerit. Aliquam congue orci quis ultricies tempus.")
                        )
                )
            |> Accordion.withAccordionItem
                (AccordionItem.default
                    |> AccordionItem.withToggle
                        (AccordionToggle.default "fourthtoggle"
                            |> AccordionToggle.withChild (H.text "Item four")
                            |> AccordionToggle.withExpanded (model == "fourthtoggle")
                            |> AccordionToggle.withAttribute (HE.onClick <| onToggle model "fourthtoggle")
                        )
                    |> AccordionItem.withContent
                        (AccordionContent.default
                            |> AccordionContent.withHidden (model /= "fourthtoggle")
                            |> AccordionContent.withChild (H.text "Donec vel posuere orci. Phasellus quis tortor a ex hendrerit efficitur. Aliquam lacinia ligula pharetra,sagittis ex ut, pellentesque diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuerecubilia Curae; Vestibulum ultricies nulla nibh. Etiam vel dui fermentum ligula ullamcorper eleifend non quistortor. Morbi tempus ornare tempus. Orci varius natoque penatibus et magnis dis parturient montes, nasceturridiculus mus. Mauris et velit neque. Donec ultricies condimentum mauris, pellentesque imperdiet liberoconvallis convallis. Aliquam erat volutpat. Donec rutrum semper tempus. Proin dictum imperdiet nibh, quis dapibus nulla. Integer sed tincidunt lectus, sit amet auctor eros.")
                        )
                )
            |> Accordion.withAccordionItem
                (AccordionItem.default
                    |> AccordionItem.withToggle
                        (AccordionToggle.default "fifthtoggle"
                            |> AccordionToggle.withChild (H.text "Item five")
                            |> AccordionToggle.withExpanded (model == "fifthtoggle")
                            |> AccordionToggle.withAttribute (HE.onClick <| onToggle model "fifthtoggle")
                        )
                    |> AccordionItem.withContent
                        (AccordionContent.default
                            |> AccordionContent.withHidden (model /= "fifthtoggle")
                            |> AccordionContent.withChild (H.text "Vivamus finibus dictum ex id ultrices. Mauris dictum neque a iaculis blandit.")
                        )
                )
            |> Accordion.toHtml
        ]

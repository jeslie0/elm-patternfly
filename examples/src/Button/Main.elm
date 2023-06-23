module Button.Main exposing (..)

import Browser
import Components.Button as Button
import Components.Button.BadgeCount as ButtonBC
import Html as H exposing (Html)
import Html.Events as HE
import Icons.Upload exposing (upload)



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
    { buttonCount : Int
    , buttonVariant : Button.Variant
    , buttonLoading : Bool
    , position : Button.IconPosition
    }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { buttonCount = 0
      , buttonVariant = Button.Primary
      , buttonLoading = True
      , position = Button.Left
      }
    , Cmd.none
    )



-- * UPDATE


type Msg
    = Foo
    | ChangeVariant
    | ToggleLoading
    | ToggleIconPosition


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Foo ->
            ( { model | buttonCount = model.buttonCount + 1 }, Cmd.none )

        ChangeVariant ->
            ( { model | buttonVariant = nextVariant model.buttonVariant }, Cmd.none )

        ToggleLoading ->
            ( { model | buttonLoading = not model.buttonLoading }, Cmd.none )

        ToggleIconPosition ->
            ( { model
                | position =
                    if model.position == Button.Left then
                        Button.Right

                    else
                        Button.Left
              }
            , Cmd.none
            )


nextVariant : Button.Variant -> Button.Variant
nextVariant variant =
    case variant of
        Button.Primary ->
            Button.Secondary

        Button.Secondary ->
            Button.Tertiary

        Button.Tertiary ->
            Button.Warning

        Button.Warning ->
            Button.Danger

        Button.Danger ->
            Button.Plain

        Button.Plain ->
            Button.Control

        Button.Control ->
            Button.Link

        Button.Link ->
            Button.Primary



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
    H.div []
        [ H.p []
            [ Button.primary
                |> Button.withChild (H.text "Primary")
                |> Button.toHtml
            , Button.secondary
                |> Button.withDanger False
                |> Button.withChild (H.text "Secondary")
                |> Button.toHtml
            , Button.secondary
                |> Button.withDanger True
                |> Button.withChild (H.text "Danger Secondary")
                |> Button.toHtml
            , Button.tertiary
                |> Button.withChild (H.text "Tertiary")
                |> Button.toHtml
            , Button.danger
                |> Button.withChild (H.text "Danger")
                |> Button.toHtml
            , Button.warning
                |> Button.withChild (H.text "Warning")
                |> Button.toHtml
            ]
        , H.p []
            [ Button.link
                |> Button.withChild (H.text "Link")
                |> Button.toHtml
            , Button.link
                |> Button.withChild (H.text "Link")
                |> Button.toHtml
            , Button.link
                |> Button.withInline True
                |> Button.withChild (H.text "Inline link")
                |> Button.toHtml
            , Button.link
                |> Button.withDanger True
                |> Button.withChild (H.text "Danger link")
                |> Button.toHtml
            ]
        , H.p []
            [ Button.tertiary
                |> Button.withBadgeCount
                    (ButtonBC.default
                        |> ButtonBC.withCount model.buttonCount
                    )
                |> Button.withChild (H.text "Badge count")
                |> Button.withAttribute (HE.onClick Foo)
                |> Button.toHtml
            , Button.variantToBuilder model.buttonVariant
                |> Button.withChild (H.text "Change my variant!")
                |> Button.withAttribute (HE.onClick ChangeVariant)
                |> Button.toHtml
            , Button.primary
                |> Button.withIsLoading model.buttonLoading
                |> Button.withAttribute (HE.onClick ToggleLoading)
                |> Button.withChild (H.text "Toggle loading")
                |> Button.toHtml
            ]
        , H.p []
            [ Button.control
                |> Button.withIcon upload
                |> Button.withChild (H.text "Upload")
                |> Button.withIconPosition model.position
                |> Button.withAttribute (HE.onClick ToggleIconPosition)
                |> Button.toHtml
            ]
        ]

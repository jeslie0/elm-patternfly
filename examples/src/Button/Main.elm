module Button.Main exposing (..)
import Browser
import Html as H exposing (Html)
import Html.Events as HE
import Components.Button as Button
import Components.Button.Variant as ButtonV
import Components.Button.BadgeCount as ButtonBC



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
    , buttonVariant : ButtonV.Variant
    , buttonLoading : Bool
    }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { buttonCount = 0
      , buttonVariant = ButtonV.Primary
      , buttonLoading = True
      }
    , Cmd.none
    )



-- * UPDATE


type Msg
    = Foo
    | ChangeVariant
    | ToggleLoading

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Foo ->
            ( { model | buttonCount = model.buttonCount + 1}, Cmd.none )

        ChangeVariant ->
            ( { model | buttonVariant = nextVariant model.buttonVariant }, Cmd.none )

        ToggleLoading ->
            ( { model | buttonLoading = not model.buttonLoading}, Cmd.none )

nextVariant : ButtonV.Variant -> ButtonV.Variant
nextVariant variant =
    case variant of
        ButtonV.Primary ->
            ButtonV.Secondary

        ButtonV.Secondary ->
            ButtonV.Tertiary

        ButtonV.Tertiary ->
            ButtonV.Warning

        ButtonV.Warning ->
            ButtonV.Danger

        ButtonV.Danger ->
            ButtonV.Plain

        ButtonV.Plain ->
            ButtonV.Control

        ButtonV.Control ->
            ButtonV.Link

        ButtonV.Link ->
            ButtonV.Primary



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
    H.div [] [
         H.p [] [
              (Button.primary
              |> Button.withChild (H.text "Primary")
              |> Button.toHtml)
             ,
              (Button.secondary
              |> Button.withDanger False
              |> Button.withChild (H.text "Secondary")
              |> Button.toHtml)
             ,
              (Button.secondary
              |> Button.withDanger True
              |> Button.withChild (H.text "Danger Secondary")
              |> Button.toHtml)
             ,
              (Button.tertiary
              |> Button.withChild (H.text "Tertiary")
              |> Button.toHtml)
             ,
              (Button.danger
              |> Button.withChild (H.text "Danger")
              |> Button.toHtml)
             ,
              (Button.warning
              |> Button.withChild (H.text "Warning")
              |> Button.toHtml)
             ]
        , H.p [] [
              (Button.link
              |> Button.withChild (H.text "Link")
              |> Button.toHtml
              )
             ,
              (Button.link
              |> Button.withChild (H.text "Link")
              |> Button.toHtml
              )
             ,
              (Button.link
              |> Button.withInline True
              |> Button.withChild (H.text "Inline link")
              |> Button.toHtml
              )
             ,
              (Button.link
              |> Button.withDanger True
              |> Button.withChild (H.text "Danger link")
              |> Button.toHtml
              )
             ]
        , H.p [] [
              (Button.tertiary
              |> Button.withBadgeCount (ButtonBC.default
                                       |> ButtonBC.withCount model.buttonCount)
              |> Button.withChild (H.text "Badge count")
              |> Button.withAttribute (HE.onClick Foo)
              |> Button.toHtml
              )
             ,
             ((Button.variantToBuilder model.buttonVariant)
              |> Button.withChild (H.text "Change my variant!")
              |> Button.withAttribute (HE.onClick ChangeVariant)
              |> Button.toHtml
              )
             ,
             (Button.primary
             |> Button.withIsLoading model.buttonLoading
             |> Button.withAttribute (HE.onClick ToggleLoading)
             |> Button.withChild (H.text "Toggle loading")
             |> Button.toHtml
             )

             ]
        ]

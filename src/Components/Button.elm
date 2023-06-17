module Components.Button exposing
    ( Builder, button
    , Variant(..), withVariant
    , withIsDisabled
    , ButtonSize(..), withButtonSize
    , withIsBlock
    , withIsLoading
    , withComponent
    , BadgeCountObject, withBadgeCount
    , ButtonType(..), withButtonType
    , withIsActive
    , toHtml
    )

{-| A **button** is a box area or text that communicates and triggers user
actions when clicked or selected. Buttons can be used to communicate
and immediately trigger actions a user can take in an application,
like submitting a form, canceling a process, or creating a new
object. Buttons can also be used to take a user to a new location,
like another page inside of a web application, or an external site
such as help or documentation.

This component corresponds to Patternfly's Button component, whose
details can be found [here](https://www.patternfly.org/v4/components/button/).


# Builder and options

We expose the opaque type `Builder` and follow the "builder pipeline"
style of customising the Patternfly HTML elements.

@docs Builder, button


# Variants

@docs Variant, withVariant


# Disabled buttons

@docs withIsDisabled


# Button sizes

@docs ButtonSize, withButtonSize


# Block level buttons

@docs withIsBlock


# Progress indicators

@docs withIsLoading


# Links as buttons

@docs withComponent


# Button with count

@docs BadgeCountObject, withBadgeCount


# Button Type

@docs ButtonType, withButtonType


# Active buttons

@docs withIsActive


# To HTML

@docs toHtml

-}

import Html as H exposing (Attribute, Html)
import Html.Attributes exposing (attribute, class, classList, disabled, type_)


{-| Opaque builder type used to build a pipeline around.
-}
type Builder msg
    = Builder (Options msg)


{-| Configurable properties for building a Patternfly button.
-}
type alias Options msg =
    { className : String -- DONE
    , component :
        List (Attribute msg)
        -> List (Html msg)
        -> Html msg -- DONE
    , buttonType : ButtonType -- DONE
    , countOptions : Maybe BadgeCountObject -- DONE
    , icon : Maybe (Icon msg) -- TODO
    , isActive : Bool -- DONE
    , isBlock : Bool -- DONE
    , isDisabled : Bool -- DONE
    , isLoading : Maybe Bool -- DONE
    , size : Maybe ButtonSize -- DONE
    , variant : Maybe Variant -- DONE
    }


{-| The default button options.
-}
defaultOptions : Options msg
defaultOptions =
    { className = ""
    , component = H.button
    , buttonType = Button
    , countOptions = Nothing
    , icon = Nothing
    , isActive = False
    , isBlock = False
    , isDisabled = False
    , isLoading = Nothing
    , size = Nothing
    , variant = Just Primary
    }


{-| The default button builder. This should be the start of a builder
pipeline.
-}
button : Builder msg
button =
    Builder defaultOptions



-- ,ariaLabel : String
-- , isAriaDisabled : IsAriaDisabled
-- , spinnerAriaLabel : String
-- , spinnerAriaLabelledBy : String
-- , spinnerAriaValueText : String
-- , inoperableEvents : List String
-- , ouiaId : OuiaId
-- , ouiaSafe : OuiaSafe
-- * Button type


{-| A button can be given a type. By default, it is just "Button", but
it can also be `Submit` or `Reset`.
-}
type ButtonType
    = Button
    | Submit
    | Reset


buttonTypeToString : ButtonType -> String
buttonTypeToString btnType =
    case btnType of
        Button ->
            "button"

        Submit ->
            "submit"

        Reset ->
            "reset"


{-| The button type pipeline builder.
-}
withButtonType : ButtonType -> Builder msg -> Builder msg
withButtonType btnType (Builder opt) =
    Builder { opt | buttonType = btnType }



-- * TODO Icon


type Position
    = Left
    | Right


type alias Icon msg =
    { icon : Html msg, position : Position }



-- * DONE IsActive


isActiveToTuple : Bool -> ( String, Bool )
isActiveToTuple isActive =
    if isActive then
        ( "pf-m-active", isActive )

    else
        ( "", isActive )


{-| A button can be styled as "active" by using the `withIsActive`
pipeline builder. By default, the active style is applied to
Patternfly when they are hovered over or clicked on. -}
withIsActive : Bool -> Builder msg -> Builder msg
withIsActive bool (Builder opt) =
    Builder { opt | isActive = bool }



-- * DONE isDisabled


{-| To indicate that an action is currently unavailable, all button
variations can be disabled by using the `withIsDisabled` pipeline
function. The boolean input determines if the button is disabled or not.
-}
withIsDisabled : Bool -> Builder msg -> Builder msg
withIsDisabled bool (Builder opts) =
    Builder { opts | isDisabled = bool }



-- * TODO Is Aria Disabled
-- type alias IsAriaDisabled =
--     Bool
-- isAriaDisabledToTuple : IsAriaDisabled -> ( String, Bool )
-- isAriaDisabledToTuple isAriaDisabled =
--     if isAriaDisabled then
--         ( "pf-m-aria-disabled", isAriaDisabled )
--     else
--         ( "", isAriaDisabled )
-- * DONE IsBlock


isBlockToTuple : Bool -> ( String, Bool )
isBlockToTuple isBlock =
    if isBlock then
        ( "pf-m-block", isBlock )

    else
        ( "", isBlock )


{-| Block level buttons span the full width of the parent element and
can be enabled using the passing `True` as the boolean into the
`withIsBlock` pipeline funcation.
-}
withIsBlock : Bool -> Builder msg -> Builder msg
withIsBlock bool (Builder opt) =
    Builder { opt | isBlock = bool }



-- * Is Loading


isLoadingToTuple : Maybe Bool -> ( String, Bool )
isLoadingToTuple mBool =
    case mBool of
        Just bool ->
            if bool then
                ( "pf-m-progress pf-m-in-progress", True )

            else
                ( "pf-m-progress", True )

        Nothing ->
            ( "", False )


isLoadingChildren : Maybe Bool -> List (Html msg) -> List (Html msg)
isLoadingChildren mBool htmls =
    case mBool of
        Just bool ->
            if bool then
                H.span
                    [ class "pf-c-button__progress" ]
                    [ H.span
                        [ class "pf-c-spinner pf-m-md"
                        , attribute "role" "progressbar"
                        ]
                        [ H.span [ class "pf-c-spinner__clipper" ] []
                        , H.span [ class "pf-c-spinner__lead-ball" ] []
                        , H.span [ class "pf-c-spinner__tail-ball" ] []
                        ]
                    ]
                    :: htmls

            else
                htmls

        Nothing ->
            htmls


{-| Progress indicators can be added to buttons to identify that an
action is in progress after a click. If a button is never going to
display a loading wheel, pass `Nothing` to the `Maybe Bool`
argument. If the button will change between displaying a loading
wheel, or not, pass `Just bool` instead.
-}
withIsLoading : Maybe Bool -> Builder msg -> Builder msg
withIsLoading mBool (Builder opt) =
    Builder { opt | isLoading = mBool }



-- * Component


{-| The default component that a Patternfly button uses is the HTML
button. We might want a different base component, such at `a` for a
hyperlink. We can use the `withComponent` pipeline builder to override
the default button component.

    myButtonBuilder =
        button
            |> withComponent (\attributes children -> H.a (HA.href "http://elm-lang.org" :: attributes) children)

-}
withComponent : (List (Attribute msg) -> List (Html msg) -> Html msg) -> Builder msg -> Builder msg
withComponent comp (Builder opts) =
    Builder { opts | component = comp }



-- * Badge count


{-| Buttons can display a `count` in the form of a badge to indicate
some value or number. We use the `withBadgeCount` pipeline builder and
pass it a BadgeCountObject, which contains a `className`, a `count`
corresponding to the number to display and an `isRead` boolean which
styles the count as either the "read" style (True) or the unread style (False).
-}
type alias BadgeCountObject =
    { className : String
    , count : Int
    , isRead : Bool
    }


{-| The pipeline builder for the Badge count. Pass Nothing for the
`Maybe BadgeCountObject` argument if you don't ever want a badge
count, otherwise, wrap your BadgeCountObject in `Just`.
-}
withBadgeCount : Maybe BadgeCountObject -> Builder msg -> Builder msg
withBadgeCount mBadgeCountObject (Builder opts) =
    Builder { opts | countOptions = mBadgeCountObject }


badgeCountChildren : Maybe BadgeCountObject -> List (Html msg) -> List (Html msg)
badgeCountChildren mBadgeCountObject htmls =
    case mBadgeCountObject of
        Nothing ->
            htmls

        Just { className, count, isRead } ->
            htmls
                ++ [ H.span
                        [ class "pf-c-button__count", class className ]
                        [ H.span
                            [ class "pf-c-badge"
                            , class <|
                                if isRead then
                                    "pf-m-read"

                                else
                                    "pf-m-unread"
                            ]
                            [ H.text (String.fromInt count) ]
                        ]
                   ]



-- * Button Size


{-| To fit into tight spaces, primary, secondary, tertiary, danger,
and warning button variations can be made smaller using the `IsSmall`
property. On the other hand, Call to action (CTA) buttons and links
direct users to complete an action. Primary, secondary, tertiary, and
link button variants can be styled as CTAs using the `IsLarge` property.
-}
type ButtonSize
    = IsSmall
    | IsLarge


buttonSizeToTuple : ButtonSize -> ( String, Bool )
buttonSizeToTuple size =
    case size of
        IsSmall ->
            ( "pf-m-small", True )

        IsLarge ->
            ( "pf-m-display-lg", True )


{-| Use `withButtonSize` to set the size of the size of the button,
using `ButtonSize`.
-}
withButtonSize : ButtonSize -> Builder msg -> Builder msg
withButtonSize size (Builder opt) =
    Builder { opt | size = Just size }



-- * Variants


isDangerToTuple : Bool -> ( String, Bool )
isDangerToTuple isDanger =
    if isDanger then
        ( " pf-m-danger", isDanger )

    else
        ( "", isDanger )


isInlineToTuple : Bool -> ( String, Bool )
isInlineToTuple isInline =
    if isInline then
        ( "pf-m-inline", isInline )

    else
        ( "", isInline )


{-| PatternFly supports several button styling variants to be used in
different scenarios as needed. The button variants can be
assigned using the `withVariant` function.

The variants allow styleing where appropriate. For instance, only the
`Secondary` and `Link` styles admit a "danger" style, hence they are
the only ones that admit that option.
-}
type Variant
    = Primary
    | Secondary { isDanger : Bool }
    | Tertiary
    | Warning
    | Danger
    | Plain
    | Control
    | Link { isDanger : Bool, isInline : Bool }


variantToTuple : Variant -> ( String, Bool )
variantToTuple variant =
    case variant of
        Primary ->
            ( "pf-m-primary", True )

        Secondary { isDanger } ->
            let
                ( dangerString, _ ) =
                    isDangerToTuple isDanger
            in
            ( "pf-m-secondary" ++ dangerString, True )

        Tertiary ->
            ( "pf-m-tertiary", True )

        Warning ->
            ( "pf-m-warning", True )

        Danger ->
            ( "pf-m-danger", True )

        Plain ->
            ( "pf-m-plain", True )

        Control ->
            ( "pf-m-control", True )

        Link { isDanger, isInline } ->
            let
                ( dangerString, _ ) =
                    isDangerToTuple isDanger

                ( inlineString, _ ) =
                    isInlineToTuple isInline
            in
            ( "pf-m-link" ++ dangerString ++ inlineString, True )


{-| Style a button with the given variant.
-}
withVariant : Variant -> Builder msg -> Builder msg
withVariant variant (Builder opt) =
    Builder { opt | variant = Just variant }



-- * Building


toClass : Builder msg -> List ( String, Bool )
toClass (Builder opts) =
    let
        pfButton =
            ( "pf-c-button", True )

        className =
            ( opts.className, not (opts.className == "") )

        isActive =
            isActiveToTuple opts.isActive

        isBlock =
            isBlockToTuple opts.isBlock

        isLoading =
            isLoadingToTuple opts.isLoading

        size =
            case opts.size of
                Nothing ->
                    ( "", False )

                Just btnSize ->
                    buttonSizeToTuple btnSize

        variant =
            case opts.variant of
                Nothing ->
                    ( "", False )

                Just var ->
                    variantToTuple var
    in
    [ pfButton, className, isActive, isBlock, isLoading, size, variant ]


toAttributes : Builder msg -> List (Attribute msg)
toAttributes (Builder opts) =
    let
        isDisabledAttr =
            disabled opts.isDisabled

        btnType =
            type_ <| buttonTypeToString opts.buttonType
    in
    [ btnType, isDisabledAttr ]


makeChildren : Builder msg -> List (Html msg) -> List (Html msg)
makeChildren (Builder opts) htmls =
    isLoadingChildren opts.isLoading <|
        badgeCountChildren opts.countOptions <|
            htmls



-- * ToHtml


{-| This function turns a Builder into a HTML component. Put this at
the end of your pipeline to get a useable button.
-}
toHtml : Builder msg -> List (Attribute msg) -> List (Html msg) -> Html msg
toHtml ((Builder opts) as builder) =
    \attributes children ->
        opts.component
            (attributes ++ ((classList <| toClass builder) :: toAttributes builder))
            (makeChildren builder children)

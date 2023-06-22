module Components.Button exposing
    ( Builder, default
    , primary, secondary, tertiary, warning, danger, plain, control, link
    , withVariant, withInline, withDanger
    , withClassName
    , withIsDisabled
    , ButtonSize(..), withButtonSize
    , withIsBlock
    , withIsLoading
    , withComponent
    , withBadgeCount
    , ButtonType(..), withButtonType
    , withIsActive
    , withAttribute, setAttributes
    , withChild, setChildren
    , toHtml
    , variantToBuilder
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

@docs Builder, default

We expose some default buttons styled with their variants. For more on
variants, see the Components.Button.Variant module.

@docs primary, secondary, tertiary, warning, danger, plain, control, link


# Variants

For more on variants, see the Components.Button.Variant module

@docs withVariant, withInline, withDanger, variantToBuilder


# Class name

@docs withClassName


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

@docs withBadgeCount


# Button Type

@docs ButtonType, withButtonType


# Active buttons

@docs withIsActive


# Attributes

@docs withAttribute, setAttributes


# Children

@docs withChild, setChildren


# To HTML

@docs toHtml

-}

import Components.Button.BadgeCount as BadgeCount
import Components.Button.Variant as Variant
import Html as H exposing (Attribute, Html)
import Html.Attributes exposing (attribute, class, classList, disabled, type_)


{-| Opaque Builder type used to build a pipeline around.
-}
type Builder msg
    = Builder (Options msg)


type alias Options msg =
    { className : Maybe String
    , component :
        List (Attribute msg)
        -> List (Html msg)
        -> Html msg
    , buttonType : ButtonType
    , countOptions : Maybe (BadgeCount.Builder msg)
    , icon : Maybe (Icon msg) -- TODO
    , isActive : Bool
    , isBlock : Bool
    , isDisabled : Bool
    , isLoading : Maybe Bool
    , size : Maybe ButtonSize
    , variant : Variant.Builder msg
    , attributes : List (Attribute msg)
    , children : List (Html msg)
    }


{-| The default button options.
-}
defaultOptions : Options msg
defaultOptions =
    { className = Nothing
    , component = H.button
    , buttonType = Button
    , countOptions = Nothing
    , icon = Nothing
    , isActive = False
    , isBlock = False
    , isDisabled = False
    , isLoading = Nothing
    , size = Nothing
    , variant = Variant.primary
    , attributes = []
    , children = []
    }


{-| The default button builder. This should be the start of a builder
pipeline.
-}
default : Builder msg
default =
    Builder defaultOptions


{-| A Button Builder with `primary` styling.
-}
primary : Builder msg
primary =
    Builder { defaultOptions | variant = Variant.primary }


{-| A Button Builder with `secondary` styling.
-}
secondary : Builder msg
secondary =
    Builder { defaultOptions | variant = Variant.secondary }


{-| A Button Builder with `tertiary` styling.
-}
tertiary : Builder msg
tertiary =
    Builder { defaultOptions | variant = Variant.tertiary }


{-| A Button Builder with `warning` styling.
-}
warning : Builder msg
warning =
    Builder { defaultOptions | variant = Variant.warning }


{-| A Button Builder with `danger` styling.
-}
danger : Builder msg
danger =
    Builder { defaultOptions | variant = Variant.danger }


{-| A Button Builder with `plain` styling.
-}
plain : Builder msg
plain =
    Builder { defaultOptions | variant = Variant.plain }


{-| A Button Builder with `control` styling.
-}
control : Builder msg
control =
    Builder { defaultOptions | variant = Variant.control }


{-| A Button Builder with `link` styling.
-}
link : Builder msg
link =
    Builder { defaultOptions | variant = Variant.link }


{-| Choose whether or to use a "danger" styling. This is different to
the `danger` variant - the default danger styling only affects the
`secondary` and `inline` variants, by changing the outline (of
`secondary`) and the text colour to red.
-}
withDanger : Bool -> Builder msg -> Builder msg
withDanger bool (Builder opts) =
    Builder { opts | variant = Variant.withDanger bool opts.variant }


{-| Choose whether to use the "inline" styling. This only applies to
`link` variants, and changes the component to `span`.
-}
withInline : Bool -> Builder msg -> Builder msg
withInline bool ((Builder opts) as builder) =
    Builder { opts | variant = Variant.withInline bool opts.variant, component = H.span }


{-| Convert a Button Variant into a Button Builder of the
corresponding style.
-}
variantToBuilder : Variant.Variant -> Builder msg
variantToBuilder var =
    case var of
        Variant.Primary ->
            primary

        Variant.Secondary ->
            secondary

        Variant.Tertiary ->
            tertiary

        Variant.Warning ->
            warning

        Variant.Danger ->
            danger

        Variant.Plain ->
            plain

        Variant.Control ->
            control

        Variant.Link ->
            link



-- ,ariaLabel : String
-- , isAriaDisabled : IsAriaDisabled
-- , spinnerAriaLabel : String
-- , spinnerAriaLabelledBy : String
-- , spinnerAriaValueText : String
-- , inoperableEvents : List String
-- , ouiaId : OuiaId
-- , ouiaSafe : OuiaSafe
-- * Class Name


{-| The button can be given a custom class name by passing in a className
string.
-}
withClassName : String -> Builder msg -> Builder msg
withClassName string (Builder opts) =
    Builder { opts | className = Just string }



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
Patternfly when they are hovered over or clicked on.
-}
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


isLoadingChildren : Maybe Bool -> List (Html msg)
isLoadingChildren mBool =
    case mBool of
        Just bool ->
            if bool then
                [ H.span
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
                ]

            else
                []

        Nothing ->
            []


{-| Progress indicators can be added to buttons to identify that an
action is in progress after a click. If a button is never going to
display a loading wheel don't pass apply this pipeline function to
it. If the button will change between displaying a loading
wheel, or not, pass `bool` instead.
-}
withIsLoading : Bool -> Builder msg -> Builder msg
withIsLoading bool (Builder opt) =
    Builder { opt | isLoading = Just bool }



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


{-| The pipeline builder for the Badge count. Don't use this pipeline
function if you don't ever want a badge count on this Button,
otherwise, pass in the appropriate BadgeCountObject.
-}
withBadgeCount : BadgeCount.Builder msg -> Builder msg -> Builder msg
withBadgeCount badgeCountBuilder (Builder opts) =
    Builder { opts | countOptions = Just badgeCountBuilder }



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


{-| Apply the given variant to the Button Builder.
-}
withVariant : Variant.Builder msg -> Builder msg -> Builder msg
withVariant varopts (Builder opts) =
    Builder { opts | variant = varopts }



-- * Attributes


{-| Add an attribute to the Accordion HTML element.
-}
withAttribute : Attribute msg -> Builder msg -> Builder msg
withAttribute attr (Builder opts) =
    Builder { opts | attributes = attr :: opts.attributes }


{-| Set the attributes of the Accordion HTML element to be the given
list of attributes.
-}
setAttributes : List (Attribute msg) -> Builder msg -> Builder msg
setAttributes attrs (Builder opts) =
    Builder { opts | attributes = attrs }



-- * Children


{-| Add a single child HTML element to the Accordion Toggle's children.
-}
withChild : Html msg -> Builder msg -> Builder msg
withChild html (Builder opts) =
    Builder { opts | children = html :: opts.children }


{-| Give a list of HTML elements and set them as the children of this
Accordion Toggle.
-}
setChildren : List (Html msg) -> Builder msg -> Builder msg
setChildren htmls (Builder opts) =
    Builder { opts | children = htmls }



-- * Building


toClass : Builder msg -> List ( String, Bool )
toClass (Builder opts) =
    let
        pfButton =
            ( "pf-c-button", True )

        className =
            case opts.className of
                Nothing ->
                    ( "", False )

                Just name ->
                    ( name, True )

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
            Variant.variantToTuple opts.variant
    in
    [ pfButton, isActive, isBlock, isLoading, size, className ] ++ variant


toAttributes : Builder msg -> List (Attribute msg)
toAttributes (Builder opts) =
    let
        isDisabledAttr =
            disabled opts.isDisabled

        btnType =
            type_ <| buttonTypeToString opts.buttonType
    in
    [ btnType, isDisabledAttr ] ++ opts.attributes


makeChildren : Builder msg -> List (Html msg)
makeChildren (Builder opts) =
    isLoadingChildren opts.isLoading
        ++ (case opts.countOptions of
                Just countOpts ->
                    opts.children ++ BadgeCount.toHtml countOpts

                Nothing ->
                    opts.children
           )



-- * ToHtml


{-| This function turns a Builder into a HTML component. Put this at
the end of your pipeline to get a useable button.
-}
toHtml : Builder msg -> Html msg
toHtml ((Builder opts) as builder) =
    opts.component
        ((classList <| toClass builder) :: toAttributes builder)
        (makeChildren builder)

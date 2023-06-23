module Components.Button exposing
    ( Builder, default
    , primary, secondary, tertiary, warning, danger, plain, control, link
    , Variant(..), withInline, withDanger, variantToBuilder
    , withClassName
    , withIsDisabled
    , ButtonSize(..), withButtonSize
    , withIsBlock
    , withIsLoading
    , withComponent
    , withBadgeCount
    , ButtonType(..), withButtonType
    , withIsActive
    , withIcon, IconPosition(..), withIconPosition
    , withAttribute, setAttributes
    , withChild, setChildren
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

@docs Builder, default

We expose some default buttons styled with their variants.

@docs primary, secondary, tertiary, warning, danger, plain, control, link


# Variants

@docs Variant, withInline, withDanger, variantToBuilder


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


# Icon

Buttons have a spot for an icon, either on the left or the right of
its main children spot. All variants support icons, except for the
plain variant. An icon doesn't have to be an honest Icon, it can be
any HTML element, however, it's a good idea to just use icons here.

@docs withIcon, IconPosition, withIconPosition


# Attributes

@docs withAttribute, setAttributes


# Children

@docs withChild, setChildren


# To HTML

@docs toHtml

-}

import Components.Button.BadgeCount as BadgeCount
import Html as H exposing (Attribute, Html)
import Html.Attributes exposing (attribute, class, classList, disabled, type_)


classes =
    { button = "pf-c-button"
    , icon = "pf-c-button__icon"
    , start = "pf-m-start"
    , end = "pf-m-end"
    , small = "pf-m-small"
    , large = "pf-m-display-lg"
    , progress = "pf-c-button__progress"
    , medium = "pf-m-md"
    , spinner =
        { spinner = "pf-c-spinner"
        , clipper = "pf-c-spinner__clipper"
        , leadBall = "pf-c-spinner__lead-ball"
        , tailBall = "pf-c-spinner__tail-ball"
        }
    , loading =
        { progress = "pf-m-progress"
        , inProgress = "pf-m-in-progress"
        }
    , block = "pf-m-block"
    , active = "pf-m-active"
    , inline = "pf-m-inline"
    , danger = "pf-m-danger"
    , link = "pf-m-link"
    , control = "pf-m-control"
    , plain = "pf-m-plain"
    , warning = "pf-m-warning"
    , tertiary = "pf-m-tertiary"
    , secondary = "pf-m-secondary"
    , primary = "pf-m-primary"
    }


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
    , icon : Maybe (IconOptions msg)
    , isActive : Bool
    , isBlock : Bool
    , isDisabled : Bool
    , isLoading : Maybe Bool
    , size : Maybe ButtonSize
    , variant : VariantBuilder msg
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
    , variant = primaryVar
    , attributes = []
    , children = []
    }


{-| The default button builder. This should be the start of a builder
pipeline.
-}
default : Builder msg
default =
    Builder defaultOptions


{-| Opaque Button Variant VariantBuilder type used to build a pipeline around.
-}
type VariantBuilder msg
    = VariantBuilder VariantOptions


type VariantOptions
    = Pri
    | Sec { isDanger : Bool }
    | Ter
    | Warn
    | Dngr
    | Pln
    | Ctrl
    | Lnk { isDanger : Bool, isInline : Bool }


{-| The "primary" button variant.
-}
primaryVar : VariantBuilder msg
primaryVar =
    VariantBuilder Pri


{-| The "secondary" button variant.
-}
secondaryVar : VariantBuilder msg
secondaryVar =
    VariantBuilder (Sec { isDanger = False })


{-| The "tertiary" button variant.
-}
tertiaryVar : VariantBuilder msg
tertiaryVar =
    VariantBuilder Ter


{-| The "warning" button variant.
-}
warningVar : VariantBuilder msg
warningVar =
    VariantBuilder Warn


{-| The "danger" button variant.
-}
dangerVar : VariantBuilder msg
dangerVar =
    VariantBuilder Dngr


{-| The "plain" button variant.
-}
plainVar : VariantBuilder msg
plainVar =
    VariantBuilder Pln


{-| The "control" button variant.
-}
controlVar : VariantBuilder msg
controlVar =
    VariantBuilder Ctrl


{-| The "link" button variant.
-}
linkVar : VariantBuilder msg
linkVar =
    VariantBuilder <| Lnk { isDanger = False, isInline = False }


{-| Choose whether or to use a "danger" styling. This is different to
the `danger` variant - the default danger styling only affects the
`secondary` and `inline` variants, by changing the outline (of
`secondary`) and the text colour to red.
-}
withDangerVar : Bool -> VariantBuilder msg -> VariantBuilder msg
withDangerVar bool ((VariantBuilder opts) as builder) =
    case opts of
        Sec _ ->
            VariantBuilder (Sec { isDanger = bool })

        Lnk linkopts ->
            VariantBuilder (Lnk { linkopts | isDanger = bool })

        _ ->
            builder


{-| Choose whether to use the "inline" styling. This only applies to
`link` variants.
-}
withInlineVar : Bool -> VariantBuilder msg -> VariantBuilder msg
withInlineVar bool ((VariantBuilder opts) as builder) =
    case opts of
        Lnk linkopts ->
            VariantBuilder <| Lnk { linkopts | isInline = bool }

        _ ->
            builder



-- * Internal


{-| Internal - don't use
-}
variantToTuple : VariantBuilder msg -> List ( String, Bool )
variantToTuple (VariantBuilder varopts) =
    case varopts of
        Pri ->
            [ ( classes.primary, True ) ]

        Sec { isDanger } ->
            [ ( classes.secondary, True ), isDangerToTuple isDanger ]

        Ter ->
            [ ( classes.tertiary, True ) ]

        Warn ->
            [ ( classes.warning, True ) ]

        Dngr ->
            [ ( classes.danger, True ) ]

        Pln ->
            [ ( classes.plain, True ) ]

        Ctrl ->
            [ ( classes.control, True ) ]

        Lnk { isDanger, isInline } ->
            [ ( classes.link, True ), isDangerToTuple isDanger, isInlineToTuple isInline ]


isDangerToTuple : Bool -> ( String, Bool )
isDangerToTuple isDanger =
    if isDanger then
        ( classes.danger, isDanger )

    else
        ( "", isDanger )


isInlineToTuple : Bool -> ( String, Bool )
isInlineToTuple isInline =
    if isInline then
        ( classes.inline, isInline )

    else
        ( "", isInline )



-- * Handy things


{-| This is an enumeration of the possible Button Variants. Combine it
with `variantToBuilder` to change a button's variant at runtime.
-}
type Variant
    = Primary
    | Secondary
    | Tertiary
    | Warning
    | Danger
    | Plain
    | Control
    | Link


{-| A Button Builder with `primary` styling.
-}
primary : Builder msg
primary =
    Builder { defaultOptions | variant = primaryVar }


{-| A Button Builder with `secondary` styling.
-}
secondary : Builder msg
secondary =
    Builder { defaultOptions | variant = secondaryVar }


{-| A Button Builder with `tertiary` styling.
-}
tertiary : Builder msg
tertiary =
    Builder { defaultOptions | variant = tertiaryVar }


{-| A Button Builder with `warning` styling.
-}
warning : Builder msg
warning =
    Builder { defaultOptions | variant = warningVar }


{-| A Button Builder with `danger` styling.
-}
danger : Builder msg
danger =
    Builder { defaultOptions | variant = dangerVar }


{-| A Button Builder with `plain` styling.
-}
plain : Builder msg
plain =
    Builder { defaultOptions | variant = plainVar }


{-| A Button Builder with `control` styling.
-}
control : Builder msg
control =
    Builder { defaultOptions | variant = controlVar }


{-| A Button Builder with `link` styling.
-}
link : Builder msg
link =
    Builder { defaultOptions | variant = linkVar }


{-| Choose whether or to use a "danger" styling. This is different to
the `danger` variant - the default danger styling only affects the
`secondary` and `inline` variants, by changing the outline (of
`secondary`) and the text colour to red.
-}
withDanger : Bool -> Builder msg -> Builder msg
withDanger bool (Builder opts) =
    Builder { opts | variant = withDangerVar bool opts.variant }


{-| Choose whether to use the "inline" styling. This only applies to
`link` variants, and changes the component to `span`.
-}
withInline : Bool -> Builder msg -> Builder msg
withInline bool (Builder opts) =
    Builder { opts | variant = withInlineVar bool opts.variant, component = H.span }


{-| Convert a Button Variant into a Button Builder of the
corresponding style.
-}
variantToBuilder : Variant -> Builder msg
variantToBuilder var =
    case var of
        Primary ->
            primary

        Secondary ->
            secondary

        Tertiary ->
            tertiary

        Warning ->
            warning

        Danger ->
            danger

        Plain ->
            plain

        Control ->
            control

        Link ->
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



-- * Icon


{-| The icon position on the Button. Should the icon be on the left or
the right of the child?
-}
type IconPosition
    = Left
    | Right


type alias IconOptions msg =
    { icon : H.Html msg
    , position : IconPosition
    }


{-| Add an icon, or general HTML element, to the given Button Builder.
-}
withIcon : Html msg -> Builder msg -> Builder msg
withIcon html ((Builder opts) as builder) =
    case opts.variant of
        VariantBuilder Pln ->
            builder

        _ ->
            Builder { opts | icon = Just { icon = html, position = Left } }


{-| Change the position of an existing icon on a Button Builder. Note
that for this function to have any affect, it must be called after
`withIcon` in the builder pipeline.
-}
withIconPosition : IconPosition -> Builder msg -> Builder msg
withIconPosition pos (Builder opts) =
    Builder { opts | icon = Maybe.map (\{ icon } -> { icon = icon, position = pos }) opts.icon }



-- * DONE IsActive


isActiveToTuple : Bool -> ( String, Bool )
isActiveToTuple isActive =
    if isActive then
        ( classes.active, isActive )

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
        ( classes.block, isBlock )

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


isLoadingToTuple : Maybe Bool -> List ( String, Bool )
isLoadingToTuple mBool =
    case mBool of
        Just bool ->
            [ ( classes.loading.progress, True ), ( classes.loading.inProgress, bool ) ]

        Nothing ->
            [ ( "", False ) ]


isLoadingChildren : Maybe Bool -> List (Html msg)
isLoadingChildren mBool =
    case mBool of
        Just bool ->
            if bool then
                [ H.span
                    [ class classes.progress ]
                    [ H.span
                        [ class classes.spinner.spinner
                        , class classes.medium
                        , attribute "role" "progressbar"
                        ]
                        [ H.span [ class classes.spinner.clipper ] []
                        , H.span [ class classes.spinner.leadBall ] []
                        , H.span [ class classes.spinner.tailBall ] []
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
otherwise, pass in the appropriate BadgeCountObject as the first Builder.
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
            ( classes.small, True )

        IsLarge ->
            ( classes.large, True )


{-| Use `withButtonSize` to set the size of the size of the button,
using `ButtonSize`.
-}
withButtonSize : ButtonSize -> Builder msg -> Builder msg
withButtonSize size (Builder opt) =
    Builder { opt | size = Just size }



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



-- * ToHtml


makeChildren : Builder msg -> List (Html msg)
makeChildren (Builder opts) =
    let
        isLoading =
            isLoadingChildren opts.isLoading

        buttonCount =
            case opts.countOptions of
                Just countOpts ->
                    BadgeCount.toHtml countOpts

                Nothing ->
                    []

        children =
            opts.children

        ( leftIcon, rightIcon ) =
            case opts.icon of
                Just { icon, position } ->
                    case position of
                        Left ->
                            ( [ H.span [ class classes.icon, class classes.start ] [ icon ] ]
                            , []
                            )

                        Right ->
                            ( [], [ H.span [ class classes.icon, class classes.end ] [ icon ] ] )

                Nothing ->
                    ( [], [] )
    in
    isLoading ++ leftIcon ++ children ++ rightIcon ++ buttonCount


toClasses : Builder msg -> List ( String, Bool )
toClasses (Builder opts) =
    let
        pfButton =
            ( classes.button, True )

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
            variantToTuple opts.variant
    in
    [ pfButton, isActive, isBlock ] ++ isLoading ++ [ size, className ] ++ variant


toAttributes : Builder msg -> List (Attribute msg)
toAttributes (Builder opts) =
    let
        isDisabledAttr =
            disabled opts.isDisabled

        btnType =
            type_ <| buttonTypeToString opts.buttonType
    in
    [ btnType, isDisabledAttr ] ++ opts.attributes


{-| This function turns a Builder into a HTML component. Put this at
the end of your pipeline to get a useable button.
-}
toHtml : Builder msg -> Html msg
toHtml ((Builder opts) as builder) =
    opts.component
        ((classList <| toClasses builder) :: toAttributes builder)
        (makeChildren builder)

module Components.Button.Variant exposing
    ( Builder
    , primary, secondary, tertiary, warning, danger, plain, control, link
    , withDanger, withInline
    , variantToTuple
    , Variant(..), variantToBuilder
    )

{-|


# Builder

@docs Builder


# Variants

@docs primary, secondary, tertiary, warning, danger, plain, control, link


# Customisation

@docs withDanger, withInline


# Utility

These are some useful objects that might be handy.

@docs Variant, variantToBuilder


# Internals

This function serve little use to a user of this library. It is
exported so the Button Builder type renders correctly.

@docs variantToTuple

-}


{-| Opaque Button Variant Builder type used to build a pipeline around.
-}
type Builder msg
    = Builder Options


type Options
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
primary : Builder msg
primary =
    Builder Pri


{-| The "secondary" button variant.
-}
secondary : Builder msg
secondary =
    Builder (Sec { isDanger = False })


{-| The "tertiary" button variant.
-}
tertiary : Builder msg
tertiary =
    Builder Ter


{-| The "warning" button variant.
-}
warning : Builder msg
warning =
    Builder Warn


{-| The "danger" button variant.
-}
danger : Builder msg
danger =
    Builder Dngr


{-| The "plain" button variant.
-}
plain : Builder msg
plain =
    Builder Pln


{-| The "control" button variant.
-}
control : Builder msg
control =
    Builder Ctrl


{-| The "link" button variant.
-}
link : Builder msg
link =
    Builder <| Lnk { isDanger = False, isInline = False }


{-| Choose whether or to use a "danger" styling. This is different to
the `danger` variant - the default danger styling only affects the
`secondary` and `inline` variants, by changing the outline (of
`secondary`) and the text colour to red.
-}
withDanger : Bool -> Builder msg -> Builder msg
withDanger bool ((Builder opts) as builder) =
    case opts of
        Sec _ ->
            Builder (Sec { isDanger = bool })

        Lnk linkopts ->
            Builder (Lnk { linkopts | isDanger = bool })

        _ ->
            builder


{-| Choose whether to use the "inline" styling. This only applies to
`link` variants.
-}
withInline : Bool -> Builder msg -> Builder msg
withInline bool ((Builder opts) as builder) =
    case opts of
        Lnk linkopts ->
            Builder <| Lnk { linkopts | isInline = bool }

        _ ->
            builder



-- * Internal


{-| Internal - don't use
-}
variantToTuple : Builder msg -> List ( String, Bool )
variantToTuple (Builder varopts) =
    case varopts of
        Pri ->
            [ ( "pf-m-primary", True ) ]

        Sec { isDanger } ->
            [ ( "pf-m-secondary", True ), isDangerToTuple isDanger ]

        Ter ->
            [ ( "pf-m-tertiary", True ) ]

        Warn ->
            [ ( "pf-m-warning", True ) ]

        Dngr ->
            [ ( "pf-m-danger", True ) ]

        Pln ->
            [ ( "pf-m-plain", True ) ]

        Ctrl ->
            [ ( "pf-m-control", True ) ]

        Lnk { isDanger, isInline } ->
            [ ( "pf-m-link", True ), isDangerToTuple isDanger, isInlineToTuple isInline ]


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



-- * Handy things


{-| This is an enumeration of the possible Button Variants. As Builder
is an opaque type, you can't pattern match on it, so we expose this
Variant type as a substitute.
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

{-| Convert a Button Variant into a Button Variant Builder of the
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

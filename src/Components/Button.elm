module Components.Button exposing
    ( BadgeCountObject
    , Builder
    , ButtonSize(..)
    , ButtonType(..)
    , Variant(..)
    , button
    , toHtml
    , withBadgeCount
    , withButtonSize
    , withButtonType
    , withIsActive
    , withIsBlock
    , withIsDisabled
    , withIsLoading
    , withVariant
    )

import Html as H exposing (Attribute, Html)
import Html.Attributes exposing (attribute, class, classList, disabled, type_)


type Builder msg
    = Builder (Options msg)


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


withIsActive : Builder msg -> Builder msg
withIsActive (Builder opt) =
    Builder { opt | isActive = True }



-- * DONE isDisabled


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


withIsBlock : Builder msg -> Builder msg
withIsBlock (Builder opt) =
    Builder { opt | isBlock = True }



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


withIsLoading : Maybe Bool -> Builder msg -> Builder msg
withIsLoading mBool (Builder opt) =
    Builder { opt | isLoading = mBool }



-- * Badge count


type alias BadgeCountObject =
    { className : String
    , count : Int
    , isRead : Bool
    }


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


withVariant : Variant -> Builder msg -> Builder msg
withVariant variant (Builder opt) =
    Builder { opt | variant = Just variant }



-- withPrimary : Builder msg -> Builder msg
-- withPrimary (Builder opt) =
--     Builder { opt | variant = Just Primary }
-- withSecondary : Builder msg -> Builder msg
-- withSecondary (Builder opt) =
--     Builder { opt | variant = Just (Secondary { isDanger = False }) }
-- withSecondaryOptions : { isDanger : Bool } -> Builder msg -> Builder msg
-- withSecondaryOptions isDanger (Builder opt) =
--     Builder { opt | variant = Just (Secondary isDanger) }
-- withTertiary : Builder msg -> Builder msg
-- withTertiary (Builder opt) =
--     Builder { opt | variant = Just Tertiary }
-- withWarning : Builder msg -> Builder msg
-- withWarning (Builder opt) =
--     Builder { opt | variant = Just Warning }
-- withDanger : Builder msg -> Builder msg
-- withDanger (Builder opt) =
--     Builder { opt | variant = Just Danger }
-- withPlain : Builder msg -> Builder msg
-- withPlain (Builder opt) =
--     Builder { opt | variant = Just Plain }
-- withLink : Builder msg -> Builder msg
-- withLink (Builder opt) =
--     Builder { opt | variant = Just (Link { isDanger = False, isInline = False }) }
-- withLinkOpts : { isDanger : Bool, isInline : Bool } -> Builder msg -> Builder msg
-- withLinkOpts rec (Builder opt) =
--     Builder { opt | variant = Just (Link rec) }


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


toHtml : Builder msg -> List (Attribute msg) -> List (Html msg) -> Html msg
toHtml ((Builder opts) as builder) =
    \attributes children ->
        opts.component
            (attributes ++ ((classList <| toClass builder) :: toAttributes builder))
            (makeChildren builder children)

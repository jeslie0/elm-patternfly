module Components.Button.BadgeCount exposing
    ( Builder, default
    , withClassName
    , withCount
    , withRead
    , toHtml
    )

{-| Buttons can display a `count` in the form of a badge to indicate
some value or number. We use the `withBadgeCount` pipeline builder and
pass it a BadgeCountObject, which contains a `className`, a `count`
corresponding to the number to display and an `isRead` boolean which
styles the count as either the "read" style (`True`) or the unread
style (`False`).


# Builder

@docs Builder, default


# Class name

@docs withClassName


# Count

@docs withCount


# Is read?

@docs withRead


# Internal

@docs toHtml

-}

import Html as H exposing (Html)
import Html.Attributes exposing (class, classList)


{-| Opaque Builder type used to build a pipeline around.
-}
type Builder msg
    = Builder Options


type alias Options =
    { className : Maybe String
    , count : Int
    , isRead : Bool
    }


defaultOptions : Options
defaultOptions =
    { className = Nothing
    , count = 0
    , isRead = False
    }


{-| The default Badge Count Builder.
-}
default : Builder msg
default =
    Builder defaultOptions


{-| Set the class name for the Badge Count HTML element.
-}
withClassName : String -> Builder msg -> Builder msg
withClassName string (Builder opts) =
    Builder { opts | className = Just string }


{-| Set the count number for the Badge Count HTML element.
-}
withCount : Int -> Builder msg -> Builder msg
withCount n (Builder opts) =
    Builder { opts | count = n }


{-| Set whether or not the Badge Count displays the "read" styling.
-}
withRead : Bool -> Builder msg -> Builder msg
withRead bool (Builder opts) =
    Builder { opts | isRead = bool }


classes : Builder msg -> List ( String, Bool )
classes (Builder opts) =
    let
        buttonCount =
            ( "pf-c-button__count", True )

        className =
            case opts.className of
                Just name ->
                    ( name, True )

                Nothing ->
                    ( "", False )
    in
    [ buttonCount, className ]


{-| Render the Badge Count Builder. Note, this should not be called if
you are using a Button Builder. The Button's `toHtml` will call this,
so you don't have to.
-}
toHtml : Builder msg -> List (Html msg)
toHtml ((Builder opts) as builder) =
    [ H.span
        [ classList << classes <| builder ]
        [ H.span
            [ class "pf-c-badge"
            , class <|
                if opts.isRead then
                    "pf-m-read"

                else
                    "pf-m-unread"
            ]
            [ H.text (String.fromInt opts.count) ]
        ]
    ]

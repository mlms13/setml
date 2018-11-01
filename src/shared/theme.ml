type t =
    | Classic
    | Open_source

type palette = {
    primary: string;
    secondary: string;
    tertiary: string;
}

let to_string = function
    | Classic -> "classic"
    | Open_source -> "open_source"

let of_string = function
    | "classic" -> Classic
    | "open_source" -> Open_source
    | ts -> raise (Invalid_argument ("Unknown theme: " ^ ts))

let num ~card = function
    | Classic | Open_source ->
        match Card.num card with
        | AttrZero -> "one"
        | AttrOne -> "two"
        | AttrTwo -> "three"

let fill ~card = function
    | Classic | Open_source ->
        match Card.fill card with
        | AttrZero -> "open"
        | AttrOne -> "shaded"
        | AttrTwo -> "solid"

let color ~card = function
    | Classic | Open_source ->
        match Card.color card with
        | AttrZero -> "red"
        | AttrOne -> "blue"
        | AttrTwo -> "green"

let shape ?(plural=false) ~card = function
    | Classic -> (
        match Card.shape card with
        | AttrZero ->
            if plural then "ovals" else "oval"
        | AttrOne ->
            if plural then "diamonds" else "diamond"
        | AttrTwo ->
            if plural then "bowties" else "bowtie")
    | Open_source -> (
        match Card.shape card with
        | AttrZero ->
            if plural then "penguins" else "penguin"
        | AttrOne ->
            if plural then "elephants" else "elephant"
        | AttrTwo ->
            if plural then "camels" else "camel")

let palette = function
    | Classic -> {
        primary = "#3f51b5";
        secondary = "#f44336";
        tertiary = "#899f51";
    }
    | Open_source -> {
        primary = "";
        secondary = "";
        tertiary = "";
    }

let card_to_string ~theme card =
    let num_attr = num ~card theme in
    let fill_attr = fill ~card theme in
    let color_attr = color ~card theme in
    let plural = card.num != AttrZero in
    let shape_attr = shape ~plural ~card theme in
    Printf.sprintf "%s %s %s %s" num_attr fill_attr color_attr shape_attr

let make_svg ~width ~height ~vx ~vy ~vw ~vh content =
    Printf.sprintf
        {eosvg|
            <svg xmlns='http://www.w3.org/2000/svg' width='%f' height='%f' viewBox='%f %f %f %f'>
                %s
            </svg>
        |eosvg}
    width height vx vy vw vh content

let make_classic_shape_svg card =
    let color = match Card.color card with
    | AttrZero -> "red"
    | AttrOne -> "blue"
    | AttrTwo -> "green"
    in
    match Card.shape card with
    | AttrZero -> ( (* oval *)
        match Card.fill card with
        | AttrZero -> ( (* open *)
            Printf.sprintf
            {eoshape|
                <path
                    style="isolation:auto;mix-blend-mode:normal;solid-color:#000;solid-opacity:1"
                    d="M200 340A160 160 0 0 0 40 500a160 160 0 0 0 160 160h600a160 160 0 0 0 160-160 160 160 0 0 0-160-160H200z"
                    color="%s"
                    overflow="visible"
                    fill="none"
                    stroke="%s"
                    stroke-width="10"
                />
            |eoshape}
            color color
        )
        | AttrOne -> ( (* shaded *)
            Printf.sprintf
            {eoshape|
                <defs>
                    <pattern id="a" patternTransform="scale(10)" height="1" width="2" patternUnits="userSpaceOnUse">
                        <path d="M0-.5h1v2H0z" />
                    </pattern>
                </defs>
                <path
                    style="isolation:auto;mix-blend-mode:normal;solid-color:#000;solid-opacity:1"
                    d="M200 340A160 160 0 0 0 40 500a160 160 0 0 0 160 160h600a160 160 0 0 0 160-160 160 160 0 0 0-160-160H200z"
                    color="%s"
                    overflow="visible"
                    fill="url(#a)"
                    fill-rule="evenodd"
                    stroke="%s"
                    stroke-width="10"
                />
            |eoshape}
            color color
        )
        | AttrTwo -> ( (* solid *)
            Printf.sprintf
            {eoshape|
                <path
                    style="isolation:auto;mix-blend-mode:normal;solid-color:#000;solid-opacity:1"
                    d="M200 340A160 160 0 0 0 40 500a160 160 0 0 0 160 160h600a160 160 0 0 0 160-160 160 160 0 0 0-160-160H200z"
                    color="%s"
                    overflow="visible"
                    fill="%s"
                    fill-rule="evenodd"
                    stroke="%s"
                    stroke-width="10"
                />
            |eoshape}
            color color color
        )
    )
    | AttrOne -> ( (* diamonds *)
        match Card.fill card with
        | AttrZero -> ( (* open *)
            Printf.sprintf
            {eoshape|
                <circle cx="500" cy="500" r="500" fill="%s" />
            |eoshape}
            color
        )
        | AttrOne -> ( (* shaded *)
            Printf.sprintf
            {eoshape|
                <circle cx="500" cy="500" r="500" fill="%s" />
            |eoshape}
            color
        )
        | AttrTwo -> ( (* solid *)
            Printf.sprintf
            {eoshape|
                <circle cx="500" cy="500" r="500" fill="%s" />
            |eoshape}
            color
        )
    )
    | AttrTwo -> ( (* bowtie *)
        match Card.fill card with
        | AttrZero -> ( (* open *)
            Printf.sprintf
            {eoshape|
                <circle cx="500" cy="500" r="500" fill="%s" />
            |eoshape}
            color
        )
        | AttrOne -> ( (* shaded *)
            Printf.sprintf
            {eoshape|
                <circle cx="500" cy="500" r="500" fill="%s" />
            |eoshape}
            color
        )
        | AttrTwo -> ( (* solid *)
            Printf.sprintf
            {eoshape|
                <circle cx="500" cy="500" r="500" fill="%s" />
            |eoshape}
            color
        )
    )

let make_card_svg ~width ~height ~theme card =
    match theme with
    | Classic | Open_source ->
        let content = make_classic_shape_svg card in
        let (vx, vy, vw, vh) = (0.0, 0.0, 1000.0, 1000.0) in
        make_svg ~width ~height ~vx ~vy ~vw ~vh content

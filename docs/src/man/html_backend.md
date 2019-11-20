HTML back-end
=============

```@meta
CurrentModule = PrettyTables
DocTestSetup = quote
    using PrettyTables
end
```

The following options are available when the HTML backend is used. Those can be
passed as keywords when calling the function [`pretty_table`](@ref):

* `table_format`: An instance of the structure [`HTMLTableFormat`](@ref) that
                  defines the general format of the HTML table.
* `cell_alignment`: A dictionary of type `(i,j) => a` that overrides that
                    alignment of the cell `(i,j)` to `a` regardless of the
                    columns alignment selected. `a` must be a symbol like
                    specified in the section `Alignment`.
* `formatter`: See the section [Formatter](@ref).
* `highlighters`: An instance of [`HTMLHighlighter`](@ref) or a tuple with a
                  list of HTML highlighters (see the section `HTML
                  highlighters`).
* `linebreaks`: If `true`, then `\\n` will be replaced by `<br>`.
                (**Default** = `false`)
* `noheader`: If `true`, then the header will not be printed. Notice that all
              keywords and parameters related to the header and sub-headers will
              be ignored. (**Default** = `false`)
* `nosubheader`: If `true`, then the sub-header will not be printed, *i.e.* the
                 header will contain only one line. Notice that this option has
                 no effect if `noheader = true`. (**Default** = `false`)
* `show_row_number`: If `true`, then a new column will be printed showing the
                     row number. (**Default** = `false`)

## HTML highlighters

A set of highlighters can be passed as a `Tuple` to the `highlighter` keyword.
Each highlighter is an instance of a structure that is a subtype of
[`AbstractHTMLHighlighter`](@ref). It also must also contain at least the
following two fields to comply with the API:

* `f`: Function with the signature `f(data,i,j)` in which should return `true`
       if the element `(i,j)` in `data` must be highlighter, or `false`
       otherwise.
* `fd`: Function with the signature `f(h,data,i,j)` in which `h` is the
        highlighter. This function must return the `HTMLDecoration` to be
        applied to the cell that must be highlighted.

The function `f` has the following signature:

    f(data, i, j)

in which `data` is a reference to the data that is being printed, `i` and `j`
are the element coordinates that are being tested. If this function returns
`true`, then the highlight style will be applied to the `(i,j)` element.
Otherwise, the default style will be used.

Notice that if multiple highlighters are valid for the element `(i,j)`, then the
applied style will be equal to the first match considering the order in the
Tuple `highlighters`.

If the function `f` returns true, then the function `fd(h,data,i,j)` will be
called and must return an element of type [`HTMLDecoration`](@ref) that contains
the decoration to be applied to the cell.

If only a single highlighter is wanted, then it can be passed directly to the
keyword `highlighter` without being inside a `Tuple`.

A default HTML highlighter [`HTMLHighlighter`](@ref) is available. It can be
constructed using the following functions:

```
HTMLHighlighter(f::Function, decoration::HTMLDecoration)
HTMLHighlighter(f::Function, fd::Function)
```

The first will apply a fixed decoration to the highlighted cell specified in
`decoration` whereas the second let the user select the desired decoration by
specifying the function `fd`.

!!! note

    If the highlighters are used together with [Formatter](@ref), then the
    change in the format **will not** affect that parameter `data` passed to the
    highlighter function `f`. It will always receive the original, unformatted
    value.

There are a set of pre-defined highlighters (with names `hl_*`) to make the
usage simpler. They are defined in the file
`./src/backends/html/predefined_highlighters.jl`.

```julia
julia> t = 0:1:20;

julia> data = hcat(t, ones(length(t))*1, 1*t, 0.5.*t.^2);

julia> header = ["Time" "Acceleration" "Velocity" "Distance";
                  "[s]"       "[m/s²]"    "[m/s]"      "[m]"];

julia> hl_v = HTMLHighlighter( (data,i,j)->(j == 3) && data[i,3] > 9, HTMLDecoration(color = "blue", font_weight = "bold"));

julia> hl_p = HTMLHighlighter( (data,i,j)->(j == 4) && data[i,4] > 10, HTMLDecoration(color = "red"));
```

```@raw html
<!DOCTYPE html>
<html>
<meta charset="UTF-8">
<style>
table, td, th {
    border-collapse: collapse
}

td, th {
    border:  ;
    padding: 6px
}
table {
    font-family: sans-serif;
}

tr:nth-child(odd) {
    background: #eee;
}

tr:nth-child(even) {
    background: #fff;
}

</style>
<body>
<table>

<tr><th style = "color: white; text-align: right; background: navy; ">Col. 1</th>
<th style = "color: white; text-align: right; background: navy; ">Col. 2</th>
<th style = "color: white; text-align: right; background: navy; ">Col. 3</th>
<th style = "color: white; text-align: right; background: navy; ">Col. 4</th>
</tr>
<tr>
<td style = "text-align: right; ">0.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "text-align: right; ">0.0</td>
<td style = "text-align: right; ">0.0</td>
</tr>
<tr>
<td style = "text-align: right; ">1.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "text-align: right; ">0.5</td>
</tr>
<tr>
<td style = "text-align: right; ">2.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "text-align: right; ">2.0</td>
<td style = "text-align: right; ">2.0</td>
</tr>
<tr>
<td style = "text-align: right; ">3.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "text-align: right; ">3.0</td>
<td style = "text-align: right; ">4.5</td>
</tr>
<tr>
<td style = "text-align: right; ">4.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "text-align: right; ">4.0</td>
<td style = "text-align: right; ">8.0</td>
</tr>
<tr>
<td style = "text-align: right; ">5.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "text-align: right; ">5.0</td>
<td style = "color: red; text-align: right; ">12.5</td>
</tr>
<tr>
<td style = "text-align: right; ">6.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "text-align: right; ">6.0</td>
<td style = "color: red; text-align: right; ">18.0</td>
</tr>
<tr>
<td style = "text-align: right; ">7.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "text-align: right; ">7.0</td>
<td style = "color: red; text-align: right; ">24.5</td>
</tr>
<tr>
<td style = "text-align: right; ">8.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "text-align: right; ">8.0</td>
<td style = "color: red; text-align: right; ">32.0</td>
</tr>
<tr>
<td style = "text-align: right; ">9.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "text-align: right; ">9.0</td>
<td style = "color: red; text-align: right; ">40.5</td>
</tr>
<tr>
<td style = "text-align: right; ">10.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "font-weight: bold; color: blue; text-align: right; ">10.0</td>
<td style = "color: red; text-align: right; ">50.0</td>
</tr>
<tr>
<td style = "text-align: right; ">11.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "font-weight: bold; color: blue; text-align: right; ">11.0</td>
<td style = "color: red; text-align: right; ">60.5</td>
</tr>
<tr>
<td style = "text-align: right; ">12.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "font-weight: bold; color: blue; text-align: right; ">12.0</td>
<td style = "color: red; text-align: right; ">72.0</td>
</tr>
<tr>
<td style = "text-align: right; ">13.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "font-weight: bold; color: blue; text-align: right; ">13.0</td>
<td style = "color: red; text-align: right; ">84.5</td>
</tr>
<tr>
<td style = "text-align: right; ">14.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "font-weight: bold; color: blue; text-align: right; ">14.0</td>
<td style = "color: red; text-align: right; ">98.0</td>
</tr>
<tr>
<td style = "text-align: right; ">15.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "font-weight: bold; color: blue; text-align: right; ">15.0</td>
<td style = "color: red; text-align: right; ">112.5</td>
</tr>
<tr>
<td style = "text-align: right; ">16.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "font-weight: bold; color: blue; text-align: right; ">16.0</td>
<td style = "color: red; text-align: right; ">128.0</td>
</tr>
<tr>
<td style = "text-align: right; ">17.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "font-weight: bold; color: blue; text-align: right; ">17.0</td>
<td style = "color: red; text-align: right; ">144.5</td>
</tr>
<tr>
<td style = "text-align: right; ">18.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "font-weight: bold; color: blue; text-align: right; ">18.0</td>
<td style = "color: red; text-align: right; ">162.0</td>
</tr>
<tr>
<td style = "text-align: right; ">19.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "font-weight: bold; color: blue; text-align: right; ">19.0</td>
<td style = "color: red; text-align: right; ">180.5</td>
</tr>
<tr>
<td style = "text-align: right; ">20.0</td>
<td style = "text-align: right; ">1.0</td>
<td style = "font-weight: bold; color: blue; text-align: right; ">20.0</td>
<td style = "color: red; text-align: right; ">200.0</td>
</tr>
</table></body></html>
```

function tagBlock(label, el, extratex)
  extratex = extratex or ""
  return { pandoc.RawBlock("latex",
      "\\tagstructbegin{tag=" .. label .."}\\tagmcbegin{tag=" .. label .. "}"),
    el,
    pandoc.RawBlock("latex", "\\leavevmode\\tagmcend\\tagstructend" .. extratex) }
end

function tagFigureBlock(alttext, el)
  return { pandoc.RawBlock("latex",
      "\\tagstructbegin{tag=Figure,alttext={" .. alttext .. "}}\\tagmcbegin{tag=Figure}"),
    el,
    pandoc.RawBlock("latex", "\\tagmcend\\tagstructend") }
end

function tagInline(label, el, extratex)
  extratex = extratex or ""
  return { pandoc.RawInline("latex",
      "{\\tagstructbegin{tag=" .. label .."}\\tagmcbegin{tag=" .. label .. "}"),
    el,
    pandoc.RawInline("latex", "\\leavevmode\\tagmcend\\tagstructend" .. extratex .. "}") }
end

function Note(el)
  return tagInline("Note", el)
end

function Link(el)
  return tagInline("Link", el)
end

function Math(el)
  return tagInline("Formula", el)
end

function Cite(el)
  return tagInline("Reference", el)
end

function Para(el)
  if el.c[1].t == "Image" then
    return tagFigureBlock(el.c[1].attributes.alt, el)
  else
    return tagBlock("P", el, "\\par")
  end
end

function CodeBlock(el)
  return tagBlock("Code", el)
end

function BulletList(el)
  return {pandoc.RawBlock("latex", "\\tagstructbegin{tag=L}"), pandoc.walk_block(el, {
    Plain = function(el)
      return { pandoc.RawBlock("latex",
        "\\tagstructbegin{tag=LI}\\tagstructbegin{tag=LBody}\\tagmcbegin{tag=P}"),
        el,
        pandoc.RawBlock("latex", "\\tagmcend\\tagstructend\\tagstructend")}
    end }),
    pandoc.RawBlock("latex", "\\tagstructend")}
end

OrderedList = BulletList

function DefinitionList(el)
  return {pandoc.RawBlock("latex", "\\tagstructbegin{tag=L}"),
    transformDefs(el),
    pandoc.RawBlock("latex", "\\tagstructend")}
end

function transformDefs(el)
  for _, def in pairs(el.content) do
    table.insert(def[1], 1,
      pandoc.RawInline("latex", "\\tagstructbegin{tag=LI}\\tagstructbegin{tag=Lbl}\\tagmcbegin{tag=Lbl}"))
    table.insert(def[1],
      pandoc.RawInline("latex", "\\tagmcend\\tagstructend"))
    table.insert(def[2][1], 1,
      pandoc.RawBlock("latex", "\\tagstructbegin{tag=LBody}\\tagmcbegin{tag=P}"))
    table.insert(def[2][1],
      pandoc.RawBlock("latex", "\\tagmcend\\tagstructend\\tagstructend"))
  end
  return el
end

function Table(el)
  return {pandoc.RawBlock("latex", "\\tagstructbegin{tag=Table}"),
    transformTable(el),
    pandoc.RawBlock("latex", "\\tagstructend")}
end

function transformTable(el)
  table.insert(el.caption, 1, pandoc.RawInline("latex", "\\tagmcbegin{tag=Caption}"))
  table.insert(el.caption, pandoc.RawInline("latex", "\\tagmcend"))
  transformRow(el.headers, "TH")
  for _, r in pairs(el.rows) do
   transformRow(r, "TD")
  end
  return el
end

function transformRow(el, rowtype)
  for i, t in ipairs(el) do
    if i == 1 then
      table.insert(t, 1, pandoc.RawBlock("latex",
        "\\tagstructbegin{tag=TR}\\tagstructbegin{tag=" .. rowtype .. "}\\tagmcbegin{tag=" .. rowtype .. "}"))
    else
      table.insert(t, 1, pandoc.RawBlock("latex",
        "\\tagstructbegin{tag=" .. rowtype .. "}\\tagmcbegin{tag=" .. rowtype .. "}"))
    end
    if i == #el then
      table.insert(t, pandoc.RawBlock("latex", "\\tagmcend\\tagstructend\\tagstructend"))
    else
      table.insert(t, pandoc.RawBlock("latex", "\\tagmcend\\tagstructend"))
    end
  end
  return el
end

function Div(el)
  if el.identifier:match "ref-" then
    return tagBlock("BibEntry", el)
  else
    return tagBlock("Div", el)
  end
end

if FORMAT:match "latex" then
  function Header(el)
    return tagBlock("H" .. el.level, el)
  end
end

function RawBlock (rb)
  if rb.format:match 'html' then
    return pandoc.RawBlock("html", rb)
  else
    local oldlatex = rb.text
    local sed = [[/^\\begin{longtable}/{s/@{}/&\n/;:a;ta;/\n@{}/!s/\n\(.\)/|\1\n/;ta;s/\n/|/};/begin.longtable/i \\\\\tagstructbegin{tag=Table}\\\tagmcbegin{tag=Table}]]
    local newlatex = pandoc.pipe('sed',{sed},oldlatex)
    local yyy = [[/^\\end{longtable}/{s/@{}/&\n/;:a;ta;/\n@{}/!s/\n\(.\)/|\1\n/;ta;s/\n/|/};/end.longtable/a \\\\\leavevmode\\\tagmcend\\\tagstructend\\\\\par]]
    local out = pandoc.pipe('sed',{yyy},newlatex)
    return pandoc.RawBlock("latex", out)
  end
end

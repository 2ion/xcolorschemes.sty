#!/usr/bin/env lua5.2
local X=require 'pl.stringx'
local L=require 'pl.List'
for l in io.open('pantones1.txt', 'r'):lines() do
  local n,c=l:match("\\definecolor{(.*)}{.*}{(.*)}")
  local cv=X.split(c,","):transform(function (e) return '0.'..e end)
  print(string.format("\\definecolor{%s}{cmyk}{%s}",n,table.concat(cv, ',')))
end

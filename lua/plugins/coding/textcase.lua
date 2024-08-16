return {
  -- convert text-case
  {
    "johmsalas/text-case.nvim",
    event = "BufRead",
    opts = {
      -- https://github.com/johmsalas/text-case.nvim?tab=readme-ov-file#string-case-conversions
      enabled_methods = {
        "to_upper_case",
        "to_lower_case",
        "to_snake_case",
        "to_dash_case",
        -- "to_title_dash_case",
        "to_constant_case",
        "to_dot_case",
        "to_phrase_case",
        "to_camel_case",
        "to_pascal_case",
        "to_title_case",
        "to_path_case",
        -- "to_upper_phrase_case",
        -- "to_lower_phrase_case",
      },
    },
    keys = { "ga" },
  },
}

export default {
  appliesToCountry: (promotion, country)->
    return true unless country? and country.length > 0
    console.log { promotion, country }
    included = false
    excluded = true
    if promotion.onlyCountries? and promotion.onlyCountries.length > 0
      included = (country in promotion.onlyCountries)
      console.log { included }
    else
      included = true    
    
    if promotion.exceptCountries? and promotion.exceptCountries.length > 0
      excluded = (country in promotion.exceptCountries)
      console.log { excluded }
    else
      excluded = false
    # (not promotion.onlyCountries? or promotion.onlyCountries.length == 0) or (country in promotion.onlyCountries) and 
    # (not promotion.exceptCountries? or promotion.exceptCountries.length == 0) or (country not in promotion.exceptCountries)
    included and not excluded
}
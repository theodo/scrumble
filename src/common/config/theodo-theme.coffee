angular.module 'NotSoShitty.common', [ 'ngMaterial' ]
.config ($mdThemingProvider) ->
  customPrimary = 
    '50': '#4b91e8'
    '100': '#3483e6'
    '200': '#1e75e3'
    '300': '#1a69cd'
    '400': '#175eb7'
    '500': '#1452A0'
    '600': '#114689'
    '700': '#0e3b73'
    '800': '#0c2f5c'
    '900': '#092445'
    'A100': '#629feb'
    'A200': '#78adee'
    'A400': '#8fbaf1'
    'A700': '#06182f'
    'contrastDefaultColor': 'light'
  $mdThemingProvider.definePalette 'customPrimary', customPrimary
  customAccent = 
    '50': '#c2e5d8'
    '100': '#b0ddcd'
    '200': '#9ed5c1'
    '300': '#8dcdb6'
    '400': '#7bc6aa'
    '500': '#69be9f'
    '600': '#57b694'
    '700': '#4aaa87'
    '800': '#429879'
    '900': '#3a876b'
    'A100': '#d4ece3'
    'A200': '#e6f4ef'
    'A400': '#f7fcfa'
    'A700': '#33755d'
    'contrastDefaultColor': 'light'
  $mdThemingProvider.definePalette 'customAccent', customAccent
  customWarn = 
    '50': '#f8c2c1'
    '100': '#f5abaa'
    '200': '#f39593'
    '300': '#f07e7c'
    '400': '#ee6865'
    '500': '#EB514E'
    '600': '#e83a37'
    '700': '#e62420'
    '800': '#d41c18'
    '900': '#be1915'
    'A100': '#fbd8d7'
    'A200': '#fdefee'
    'A400': '#ffffff'
    'A700': '#a71613'
    'contrastDefaultColor': 'light'
  $mdThemingProvider.definePalette 'customWarn', customWarn
  customBackground = 
    '50': '#ffffff'
    '100': '#ffffff'
    '200': '#ffffff'
    '300': '#ffffff'
    '400': '#fcfcfc'
    '500': '#EFEFEF'
    '600': '#e2e2e2'
    '700': '#d5d5d5'
    '800': '#c9c9c9'
    '900': '#bcbcbc'
    'A100': '#ffffff'
    'A200': '#ffffff'
    'A400': '#ffffff'
    'A700': '#afafaf'
  $mdThemingProvider.definePalette 'customBackground', customBackground
  $mdThemingProvider.theme 'default'
    # .primaryPalette 'teal'
    .primaryPalette 'customPrimary', {
        'default':'300'
        'hue-2':'100'
    }
    .accentPalette 'customAccent',{
        'default': '700'
        'hue-2': '900'
    }
    .warnPalette 'customWarn', {
        'default':'500'
    }
    .backgroundPalette 'customBackground'

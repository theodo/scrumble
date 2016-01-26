angular.module 'Scrumble.common'
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
    $mdThemingProvider.theme 'default'
        .primaryPalette 'customPrimary', {
            'default': '300'
            'hue-2': '100'
            'hue-3': '50'
        }
        .accentPalette 'red'
        .warnPalette 'red'
        .backgroundPalette 'grey'

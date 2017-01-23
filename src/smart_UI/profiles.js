const webpack = require('webpack');
const path = require('path');

const BUILD_DIR = path.resolve(__dirname, 'app/dist');
const APP_DIR = path.resolve(__dirname, 'app');
const SRC_DIR = path.resolve(__dirname, 'app/src');
const STYLE_DIR = path.resolve(__dirname, 'app/styles');

module.exports = {
    production: {
        vars: { //section with variables passed to webpack.DefinePlugin
            SERVICES_PATH: "'/services/services.js'"
        },

        config: { //section with config merged with main webpack config
            entry: {
                "services": SRC_DIR + '/services/services.js'
            },
            devtool: 'cheap-module-source-map',
            plugins: [
                new webpack.optimize.UglifyJsPlugin(),
                new webpack.DefinePlugin({
                    'process.env': {
                        'NODE_ENV': JSON.stringify('production')
                    }
                })
            ]
        }
    },

    testing: {
        vars: { //section with variables passed to webpack.DefinePlugin
            SERVICES_PATH: "'/services/services.js'"
        },

        config: { //section with config merged with main webpack config
            entry: {
                "services": SRC_DIR + '/services/services.js'
            },
            devtool: 'cheap-module-source-map'
        }
    },

    coreinternal: {
        vars: {},

        config: {
            entry: {},
            devtool: 'cheap-module-source-map',
        }
    },

    dev: {
        activeByDefault: true,
        vars: {
            SERVICES_PATH: "'/mock_data/mocks.js'"
        },

        config: {
            entry: {
                services: SRC_DIR + '/mock_data/mocks.js'
            },
            devtool: 'eval-source-map',
            debug: true,
            devServer: {
                outputPath: BUILD_DIR,
                contentBase: APP_DIR,
                hot: true,
                inline: true
            }
        }
    }
};

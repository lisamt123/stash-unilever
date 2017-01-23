const webpack = require('webpack');
const path = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require("copy-webpack-plugin");
const webpackProfiles = require('webpack-profiles');

const BUILD_DIR = path.resolve(__dirname, 'app/dist');
const APP_DIR = path.resolve(__dirname, 'app');
const SRC_DIR = path.resolve(__dirname, 'app/src');
const STYLE_DIR = path.resolve(__dirname, 'app/styles');

var config = {
    entry: {
        ui: SRC_DIR + '/ui/index.jsx',
           contracts: [SRC_DIR + '/../../contracts/contracts.js',SRC_DIR + '/../../contracts_cust/contracts_cust.js'],
        vendor: [
            "bunyan",
            "animate.css",
            "chartist",
            "lodash",
            "moment",
            "react",
            "react-addons-css-transition-group",
            "react-dom",
            "react-lightning-design-system",
            "jsforce"
        ]
    },

    output: {
        path: BUILD_DIR,
        publicPath: '/dist/',
        filename: '[name].js'
    },

    node: {
        fs: 'empty'
    },

    resolve: {
        extensions: ['', '.js', '.jsx'],
        alias: {
            'animate.css': __dirname + '/node_modules/animate.css/animate.css',
            'chartist.css': __dirname + '/node_modules/chartist/dist/chartist.min.css'
        }
    },

    module: {
        loaders: [
            {
                test: /\.jsx$/,
                exclude: /node_modules/,
                loader: 'babel',
                query: {
                    presets: ['es2015', 'react']
                }
            },
            {
                test: /\.js$/,
                exclude: /(node_modules|bower_components)/,
                loader: 'babel',
                query: {
                    presets: ['es2015']
                }
            },
            {
                test: /\.less$/,
                loader: ExtractTextPlugin.extract("style-loader", "css-loader?sourceMap!less-loader?sourceMap")
            },
            {
                test: /\.css$/,
                loader: ExtractTextPlugin.extract("style-loader", "css-loader?sourceMap")
            },
            {
                test: /\.(eot|woff|woff2|ttf|otf)$/,
                loader: require.resolve('file-loader')
            }
        ]
    },

    plugins: [
        new ExtractTextPlugin('[name].css'),
        new webpack.HotModuleReplacementPlugin(),
        new webpack.optimize.CommonsChunkPlugin("vendor", "vendor.js")
    ]
};

module.exports = webpackProfiles(config, {profilesFilename: 'profiles.js'});

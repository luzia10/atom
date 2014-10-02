_ = require 'underscore-plus'
{deprecate} = require 'grim'
{specificity} = require 'clear-cut'
{Subscriber} = require 'emissary'
{GrammarRegistry, ScopeSelector} = require 'first-mate'
ScopedPropertyStore = require 'scoped-property-store'
PropertyAccessors = require 'property-accessors'

{$, $$} = require './space-pen-extensions'
Token = require './token'

# Extended: Syntax class holding the grammars used for tokenizing.
#
# An instance of this class is always available as the `atom.syntax` global.
#
# The Syntax class also contains properties for things such as the
# language-specific comment regexes. See {::getProperty} for more details.
module.exports =
class Syntax extends GrammarRegistry
  PropertyAccessors.includeInto(this)
  Subscriber.includeInto(this)
  atom.deserializers.add(this)

  @deserialize: ({grammarOverridesByPath}) ->
    syntax = new Syntax()
    syntax.grammarOverridesByPath = grammarOverridesByPath
    syntax

  constructor: ->
    super(maxTokensPerLine: 100)

  serialize: ->
    {deserializer: @constructor.name, @grammarOverridesByPath}

  createToken: (value, scopes) -> new Token({value, scopes})

  # Deprecated: Used by settings-view to display snippets for packages
  @::accessor 'scopedProperties', ->
    deprecate("Use Syntax::getProperty instead")
    @propertyStore.propertySets

  addProperties: (args...) ->
    deprecate 'Consider using atom.config.set() instead. A direct (but private) replacement is available at atom.config.addScopedDefaults().'
    atom.config.addScopedDefaults(args...)

  removeProperties: (name) ->
    deprecate 'A direct (but private) replacement is available at atom.config.removeScopedSettingsForName().'
    atom.config.removeScopedSettingsForName(name)

  clearProperties: ->
    deprecate 'A direct (but private) replacement is available at atom.config.clearScopedSettings().'
    atom.config.clearScopedSettings()

  getProperty: (scope, keyPath) ->
    deprecate 'A direct (but private) replacement is available at atom.config.getRawScopedValue().'
    atom.config.getRawScopedValue(scope, keyPath)

  propertiesForScope: (scope, keyPath) ->
    deprecate 'A direct (but private) replacement is available at atom.config.settingsForScopeDescriptor().'
    atom.config.settingsForScopeDescriptor(scope, keyPath)

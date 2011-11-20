Qstate
========================

Qstate attempts to provide an easy way to keep all of your applications state information, basically the URL-Parameters, in one place.

It does so by providing different classes for different types of parameters (called plugins) like:
 * Date/DateTime
 * Rails parameters (action, controller)
 * Query parameters (database where parameters)
 * MapReduce parameters
 * Confidential parameters (user name, pub/priv key)
 * View parameters (similar to Rails, but not specific for rails)

QState will serialize/deserialize it's stored information as/from
 * String (URL)
 * Hash or
 * JSON

Overview
----------------

The FilterModel (find a better name) is the organizing model. It knows about all configured plugins and creates dynamic
setters and getters for them.

# Create a new FilterModel
qstate = Qstate::Filtermodel.new
# Add values
qstate.view.add_value(:key, "value")
qstate.view.add_value(:key1, "value1")
qstate.query.add_value(:key2, :value2")

Now you serialize this information for example in URI format with:

uri = qstate.uri

and you can then transform this URI back into a Filtermodel by doing

qstate2 = Qstate::Filermodel.new(uri)

The parameters in the uri will be prefixed with a the following two characters:
* Rails : '' (Rails parameters are not prefixed, so that those params can be used in rails and within qstate)
* Date/DateTime: 't_'
* View: 'v_'
* Query: 'q_'
* Confidential: '' (Confidential objects can not be serialized and have therefore no prefix)
* MapReduce: 'm_'


Extensibility
-------------------

Qstate is designed around the principle that I don't know what you need. Therefore, Qstate can be configured in such a way
that only those you need, are available. Currently the complete codebase is loaded, but this will change in further releases as well.

If there is the need for a new plugin, it is easily written and integrated without having to interact with other plugins.

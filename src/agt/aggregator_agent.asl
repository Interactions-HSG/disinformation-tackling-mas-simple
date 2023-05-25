org_name("disinformation_tackling_org").

+disinformation_tackling_team(ArticleId, GroupName) : org_name(OrgName) <-
    ?focusing(_,OrgName,"ora4mas.nopl.OrgBoard",_,_,_);
    .print("Joining group: ", GroupName);
    adoptRole(aggregator).

+?focusing(_,OrgName,"ora4mas.nopl.OrgBoard",_,_,_) : true <-
    lookupArtifact(OrgName, OrgArtId);
    focus(OrgArtId).

+!aggregate_article_evaluations: true <-
    .print("Aggregating").

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("inc/skills.asl") }
COSIDE Prompting Framework for Architecture Documentation
C - Context
You are Claude creating C4-style architecture diagrams for GBS, a global billing platform managing transaction lifecycle from payment authorization to merchant payout. The system integrates with external payment processors, handles compliances for different geographies, and processes cross-border payments with multiple stakeholder groups requiring different architectural perspectives.
O - Objective
Create accurate LikeC4 architecture diagrams with multiple focused views that enable business stakeholders, technical teams, and architects to understand system components, data flows, and business processes relevant to their roles while following proper LikeC4 syntax standards.
S - Scope
Three comprehensive diagrams covering: (1) System context with external integrations, (2) Technical architecture with microservices and infrastructure, (3) Business process flows from onboarding to payout. Each diagram must include 5-8 focused views for different stakeholder perspectives using proper LikeC4 formatting.
I - Interest Areas

Transaction Flow: Ingestion → Billing → Settlement → Payout
External Integrations: Payment processors, regulatory bodies, banking systems
Compliance: Fee Calculation, tax validation, regulatory reporting
Technical Architecture: Microservices, databases, event streams, AWS infrastructure
Business Processes: Merchant onboarding, fee calculation

D - Deliverables
Three LikeC4 diagrams with proper specification blocks, element styling, and multiple views:

System Context (5 views): ecosystem, payments, regulatory, financial, merchant experience
Technical Architecture (7 views): complete system, transaction processing, billing, settlement, portals, data layer, event enrichment
Business Process Flow (7 views): complete journey, onboarding, transaction processing, billing, compliance, settlement, self-service

E - Example
likec4specification {
  element ctx_person {
    style {
      color blue
      shape person
    }
  }
  element ctx_system {
    style {
      color red
    }
  }
}

model {
  ctx_merchant = ctx_person "Merchants" {
    description "Businesses receiving payments through Skein"
  }
  ctx_skein = ctx_system "Skein Platform" {
    description "Comprehensive LatAm billing platform"
  }
  ctx_merchant -> ctx_skein "Views receivables, manages payments"
}

views {
  view ctx_overview {
    title "System Context Overview"
    include *
  }
  view ctx_merchant_focus {
    title "Merchant Experience"
    include ctx_merchant ctx_skein
  }
}


Each diagram must use correct LikeC4 syntax with element types, style definitions within specification blocks, and descriptive relationships showing system interactions.

Don't assume anything, use only the context provided, ask clarifying questions if something is not clear and for better output